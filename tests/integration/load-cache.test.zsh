#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
# Resolve to absolute path so symlinks work regardless of cwd.
_ZPM_DIR="${_ZPM_DIR:A}"

# Isolated, throwaway dirs so we never touch the user's real cache/plugins.
# The whole body runs inside an `always` block so the sandbox is removed even
# on error. Do NOT use `trap ... EXIT` here: this file is sourced by run.zsh,
# and an EXIT trap would clobber the harness's TRAPEXIT summary handler.
sandbox="$(mktemp -d)"
{
  export ZSH_TMP_DIR="${sandbox}/tmp"
  export ZSH_DATA_HOME="${sandbox}/data"
  export ZSH_CACHE_HOME="${sandbox}/cache"
  export _ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
  export _ZPM_CACHE="${ZSH_TMP_DIR}/zpm-cache.zsh"
  export _ZPM_CACHE_ASYNC="${ZSH_TMP_DIR}/zpm-cache-async.zsh"
  export _ZPM_COMPDUMP="${ZSH_CACHE_HOME}/zcompdump"
  mkdir -p "${ZSH_TMP_DIR}/functions" "${ZSH_TMP_DIR}/bin" "${_ZPM_PLUGINS_DIR}" "${ZSH_CACHE_HOME}"

  # Link the fixture as a @dir plugin named fake-plugin.
  # @zpm-get-plugin-path maps '@dir/fake-plugin' -> ${_ZPM_PLUGINS_DIR}/@dir---fake-plugin
  # @zpm-get-plugin-basename returns 'fake-plugin'; @zpm-get-plugin-file-path strips
  # the '-plugin' suffix and resolves to 'fake.plugin.zsh'.
  ln -s "${_ZPM_DIR}/tests/fixtures/fake-plugin" "${_ZPM_PLUGINS_DIR}/@dir---fake-plugin"

  # GAP 2: p10k fixture.  @zpm-get-plugin-path maps 'romkatv/powerlevel10k'
  # -> ${_ZPM_PLUGINS_DIR}/romkatv---powerlevel10k.  The resolver finds
  # 'powerlevel10k.zsh' (basename_clean = 'powerlevel10k').
  ln -s "${_ZPM_DIR}/tests/fixtures/fake-p10k" "${_ZPM_PLUGINS_DIR}/romkatv---powerlevel10k"

  # GAP 3: async fixture.  @dir/fake-async -> ${_ZPM_PLUGINS_DIR}/@dir---fake-async.
  # basename 'fake-async' (clean), resolver finds 'fake-async.plugin.zsh'.
  ln -s "${_ZPM_DIR}/tests/fixtures/fake-async" "${_ZPM_PLUGINS_DIR}/@dir---fake-async"

  fpath=("${_ZPM_DIR}/functions" $fpath)
  autoload -Uz compinit
  source "${_ZPM_DIR}/lib/init.zsh"

  # Prerequisite: imperative.zsh normally declares _ZPM_plugins_full and the
  # parallel-runner vars before @zpm-load-plugins is ever called.  Source only
  # init.zsh here, so we recreate those preconditions manually.
  declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
  declare -g _zpm_parallel_format _zpm_parallel_launcher _zpm_parallel_item

  @zpm-load-plugins '@dir/fake-plugin'

  # Sourcing ran the plugin body.
  assert_eq '1' "${ZPM_FAKE_PLUGIN_LOADED}" 'fake plugin body executed on load'

  # Bookkeeping recorded the source file.
  # Using a variable subscript avoids zsh parsing '@' as the '@' subscript flag
  # (which would mangle a bareword subscript like [@dir/fake-plugin]).
  _key='@dir/fake-plugin'
  assert_eq "${_ZPM_PLUGINS_DIR}/@dir---fake-plugin/fake.plugin.zsh" \
    "${_ZPM_file_for_source["$_key"]}" 'source file recorded'

  # GAP 2: load powerlevel10k via its github canonical name so
  # @zpm-background-initialization recognises the 'romkatv/powerlevel10k' key
  # and injects POWERLEVEL9K_INSTALLATION_DIR into the sync cache.
  @zpm-load-plugins 'romkatv/powerlevel10k'

  # GAP 3: load the async fixture via a distinct name so @zpm-load-plugins does
  # not skip it as already-loaded.  The ',async' tag routes it through
  # @zpm-async-source -> _ZPM_plugins_for_async_source / _ZPM_file_for_async_source.
  @zpm-load-plugins '@dir/fake-async,async'

  _async_key='@dir/fake-async'
  assert_eq "${_ZPM_PLUGINS_DIR}/@dir---fake-async/fake-async.plugin.zsh" \
    "${_ZPM_file_for_async_source["$_async_key"]}" 'async source file recorded'

  # Generate the cache and assert its content.
  # 'is' is the cache-invalidation key @zpm-background-initialization writes to $ZSH_TMP_DIR/is
  is='test'
  @zpm-background-initialization

  assert_match 'ZPM_FAKE_PLUGIN_LOADED' "$(<${_ZPM_CACHE})" 'cache contains plugin body'
  assert_match '\(\)\{' "$(<${_ZPM_CACHE})" 'cache wraps plugin in anon function'

  # GAP 2: the sync cache must carry the POWERLEVEL9K_INSTALLATION_DIR export.
  assert_match 'POWERLEVEL9K_INSTALLATION_DIR' "$(<${_ZPM_CACHE})" 'p10k injection in cache'

  # GAP 3: async plugin body must be in the ASYNC cache, not the sync cache.
  assert_match 'ZPM_FAKE_ASYNC_LOADED' "$(<${_ZPM_CACHE_ASYNC})" 'async plugin in async cache'
} always {
  # NIT: guard against empty sandbox var before removing.
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
