#!/usr/bin/env zsh
# Regression test for https://github.com/zpm-zsh/zpm/issues/46
#
# A plugin that locates itself (zsh-syntax-highlighting, zsh-history-substring-search,
# enhancd, ...) must resolve the same installation directory on a warm start, where the
# generated cache is the only thing sourced, as it does on a cold start.
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
_ZPM_DIR="${_ZPM_DIR:A}"

# Isolated, throwaway dirs so we never touch the user's real cache/plugins.
# Body runs inside `always` so the sandbox is removed even on error. Do NOT use
# `trap ... EXIT`: this file is sourced by run.zsh and would clobber the harness
# TRAPEXIT summary handler.
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

  fpath=("${_ZPM_DIR}/functions" $fpath)
  autoload -Uz compinit
  source "${_ZPM_DIR}/lib/init.zsh"

  # init.zsh only declares these; it does not clear values a previous test left behind.
  _ZPM_autoload=()
  _ZPM_plugins_for_source=()
  _ZPM_plugins_for_async_source=()
  _ZPM_file_for_source=()
  _ZPM_file_for_async_source=()

  # imperative.zsh normally declares these before @zpm-load-plugins runs.
  declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
  declare -g _zpm_parallel_format _zpm_parallel_launcher _zpm_parallel_item

  # Same fixture under two plugin names so the sync and the async cache can both be
  # checked. The async one names its file explicitly with ',source:' because the
  # basename resolver would look for 'self-locating-async.plugin.zsh'.
  # Copied, not symlinked: the fixture resolves itself with ${0:A}, which would follow
  # a symlink back out of the sandbox.
  local plugin_dir="${_ZPM_PLUGINS_DIR}/@dir---self-locating"
  local plugin_async_dir="${_ZPM_PLUGINS_DIR}/@dir---self-locating-async"
  cp -r "${_ZPM_DIR}/tests/fixtures/self-locating" "${plugin_dir}"
  cp -r "${_ZPM_DIR}/tests/fixtures/self-locating" "${plugin_async_dir}"

  # Cold start: a plain `source`, which is what the plugin is written for. This is the
  # reference value every other assertion is compared against.
  @zpm-load-plugins '@dir/self-locating'
  assert_eq "${plugin_dir}" "${ZPM_SELFLOC_DIR}" 'cold start: plugin resolves its own dir'

  @zpm-load-plugins '@dir/self-locating-async,async,source:self-locating.plugin.zsh'

  # 'is' is the cache-invalidation key written to $ZSH_TMP_DIR/is. The warm shell below
  # must use the same value, otherwise the cache tail calls @zpm-clean, which wipes
  # ZSH_TMP_DIR and re-execs zsh.
  is='test'
  @zpm-background-initialization

  # Warm start: a brand new zsh whose only input is the generated cache.
  local runner="${sandbox}/warm.zsh"
  cat > "${runner}" <<RUNNER
fpath=("${_ZPM_DIR}/functions" \$fpath)
autoload -Uz compinit
is='test'
source "\$1"
print -r -- "\${ZPM_SELFLOC_DIR}"
print -r -- "\${ZPM_SELFLOC_X}"
print -r -- "\${ZPM_SELFLOC_ZERO}"
RUNNER

  local -a warm
  warm=( "${(@f)$(ZSH_TMP_DIR="${ZSH_TMP_DIR}" _ZPM_COMPDUMP="${_ZPM_COMPDUMP}" \
    zsh -f "${runner}" "${_ZPM_CACHE}" 2>/dev/null)}" )

  assert_eq "${plugin_dir}" "${warm[1]}" 'warm start: plugin resolves its own dir from cache'
  assert_eq "${plugin_dir}" "${warm[2]}" 'warm start: %x points at the plugin file, not the cache'
  assert_eq "${plugin_dir}/self-locating.plugin.zsh" "${warm[3]}" 'warm start: ZERO is set to the plugin file'

  local -a warm_async
  warm_async=( "${(@f)$(ZSH_TMP_DIR="${ZSH_TMP_DIR}" _ZPM_COMPDUMP="${_ZPM_COMPDUMP}" \
    zsh -f "${runner}" "${_ZPM_CACHE_ASYNC}" 2>/dev/null)}" )

  assert_eq "${plugin_async_dir}" "${warm_async[1]}" 'warm start: async plugin resolves its own dir from cache'
} always {
  # Do not leave sandbox paths in the global accumulators: run.zsh sources every test
  # into one shell, and a later test calling @zpm-background-initialization would try
  # to read files from this (now deleted) sandbox.
  _ZPM_plugins_for_source=()
  _ZPM_plugins_for_async_source=()
  _ZPM_file_for_source=()
  _ZPM_file_for_async_source=()
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
