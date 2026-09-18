#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
_ZPM_DIR="${_ZPM_DIR:A}"

sandbox="$(mktemp -d)"
{
  export ZSH_TMP_DIR="${sandbox}/tmp"
  export ZSH_DATA_HOME="${sandbox}/data"
  export ZSH_CACHE_HOME="${sandbox}/cache"
  export _ZPM_CACHE="${ZSH_TMP_DIR}/zpm-cache.zsh"
  export _ZPM_CACHE_ASYNC="${ZSH_TMP_DIR}/zpm-cache-async.zsh"
  export _ZPM_COMPDUMP="${ZSH_CACHE_HOME}/zcompdump"
  mkdir -p "${ZSH_TMP_DIR}" "${ZSH_DATA_HOME}" "${ZSH_CACHE_HOME}"

  # Create dummy cache files
  touch "${_ZPM_CACHE}" "${_ZPM_CACHE_ASYNC}" "${_ZPM_COMPDUMP}"

  # Create a dummy plugin directory in fpath with .git hierarchy
  plugin_dir="${sandbox}/fake-plugin"
  mkdir -p "${plugin_dir}/.git/refs/heads"
  echo "ref: refs/heads/master" > "${plugin_dir}/.git/HEAD"
  echo "dummy-hash" > "${plugin_dir}/.git/refs/heads/master"
  echo "echo 'hello'" > "${plugin_dir}/fake-plugin.zsh"

  # A plugin whose directory is NOT in fpath, but whose file the generated cache sources.
  # This is the zpm-zsh/helpers case: it is loaded in lib/imperative.zsh before the
  # auto-zcompiling `source` override exists, so nothing else ever compiles it.
  sourced_dir="${sandbox}/sourced-plugin"
  mkdir -p "${sourced_dir}"
  echo "echo 'sync'" > "${sourced_dir}/sourced.plugin.zsh"
  echo "echo 'async'" > "${sourced_dir}/sourced-async.plugin.zsh"
  typeset -Ag _ZPM_file_for_source=( '@dir/sourced' "${sourced_dir}/sourced.plugin.zsh" )
  typeset -Ag _ZPM_file_for_async_source=( '@dir/sourced-async' "${sourced_dir}/sourced-async.plugin.zsh" )

  fpath=("${plugin_dir}" "${_ZPM_DIR}/functions" $fpath)
  autoload -Uz @zpm-compile

  # Run @zpm-compile with GLOB_DOTS enabled
  setopt GLOB_DOTS
  @zpm-compile

  assert_eq '1' "$([[ -f "${plugin_dir}/fake-plugin.zsh.zwc" ]] && echo 1 || echo 0)" 'plugin file was compiled to zwc'
  assert_eq '0' "$([[ -f "${plugin_dir}/.git/refs/heads/master.zwc" ]] && echo 1 || echo 0)" '.git/refs/heads/master was NOT compiled'
  assert_eq '0' "$([[ -f "${plugin_dir}/.git/HEAD.zwc" ]] && echo 1 || echo 0)" '.git/HEAD was NOT compiled'

  # The cache sources these by path, so they must be byte-compiled or every warm start
  # re-parses them.
  assert_eq '1' "$([[ -f "${sourced_dir}/sourced.plugin.zsh.zwc" ]] && echo 1 || echo 0)" \
    'sync plugin file sourced by the cache was compiled'
  assert_eq '1' "$([[ -f "${sourced_dir}/sourced-async.plugin.zsh.zwc" ]] && echo 1 || echo 0)" \
    'async plugin file sourced by the cache was compiled'
} always {
  # run.zsh sources every test into one shell: leaving sandbox paths in the global
  # accumulators would hand them to whichever later test reads them.
  _ZPM_file_for_source=()
  _ZPM_file_for_async_source=()
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
