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

  fpath=("${plugin_dir}" "${_ZPM_DIR}/functions" $fpath)
  autoload -Uz @zpm-compile

  # Run @zpm-compile with GLOB_DOTS enabled
  setopt GLOB_DOTS
  @zpm-compile

  assert_eq '1' "$([[ -f "${plugin_dir}/fake-plugin.zsh.zwc" ]] && echo 1 || echo 0)" 'plugin file was compiled to zwc'
  assert_eq '0' "$([[ -f "${plugin_dir}/.git/refs/heads/master.zwc" ]] && echo 1 || echo 0)" '.git/refs/heads/master was NOT compiled'
  assert_eq '0' "$([[ -f "${plugin_dir}/.git/HEAD.zwc" ]] && echo 1 || echo 0)" '.git/HEAD was NOT compiled'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
