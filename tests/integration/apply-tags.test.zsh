#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
_ZPM_DIR="${_ZPM_DIR:A}"

sandbox="$(mktemp -d)"
{
  export ZSH_TMP_DIR="${sandbox}/tmp"
  export ZSH_DATA_HOME="${sandbox}/data"
  export ZSH_CACHE_HOME="${sandbox}/cache"
  export _ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
  mkdir -p "${ZSH_TMP_DIR}/functions" "${ZSH_TMP_DIR}/bin" "${_ZPM_PLUGINS_DIR}" "${ZSH_CACHE_HOME}"

  fpath=("${_ZPM_DIR}/functions" $fpath)
  source "${_ZPM_DIR}/lib/init.zsh"

  declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
  declare -g _zpm_parallel_format _zpm_parallel_launcher _zpm_parallel_item

  # Create a plugin with script, bin, and functions
  local plugin_dir="${_ZPM_PLUGINS_DIR}/@dir---apply-pkg"
  mkdir -p "${plugin_dir}/bin" "${plugin_dir}/functions"
  echo "echo 'bin-tool'" > "${plugin_dir}/bin/mytool"
  echo "#completion" > "${plugin_dir}/functions/_mytool"
  echo "export APPLY_PKG_LOADED=1" > "${plugin_dir}/apply-pkg.zsh"

  # Test 1: apply:path only (no source, no fpath)
  @zpm-load-plugins '@dir/apply-pkg,apply:path'
  local _key='@dir/apply-pkg'
  assert_eq '0' "$([[ -n "${_ZPM_file_for_source["$_key"]}" ]] && echo 1 || echo 0)" 'apply:path does not source plugin'
  assert_eq '1' "$([[ -f "${ZSH_TMP_DIR}/bin/mytool" ]] && echo 1 || echo 0)" 'apply:path copied bin to tmp bin'

  # Test 2: apply:fpath only
  local plugin2_dir="${_ZPM_PLUGINS_DIR}/@dir---completions-only"
  mkdir -p "${plugin2_dir}/functions"
  echo "#comp" > "${plugin2_dir}/functions/_comp"
  echo "export COMP_LOADED=1" > "${plugin2_dir}/completions-only.zsh"

  @zpm-load-plugins '@dir/completions-only,apply:fpath'
  local _key2='@dir/completions-only'
  assert_eq '0' "$([[ -n "${_ZPM_file_for_source["$_key2"]}" ]] && echo 1 || echo 0)" 'apply:fpath does not source plugin'
  assert_eq '1' "$([[ -f "${ZSH_TMP_DIR}/functions/_comp" ]] && echo 1 || echo 0)" 'apply:fpath copied function to tmp functions'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
