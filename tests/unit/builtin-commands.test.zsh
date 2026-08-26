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
  mkdir -p "${ZSH_TMP_DIR}" "${_ZPM_PLUGINS_DIR}" "${ZSH_CACHE_HOME}"

  fpath=("${_ZPM_DIR}/functions" $fpath)
  source "${_ZPM_DIR}/lib/init.zsh"

  declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
  declare -g _zpm_parallel_format _zpm_parallel_launcher _zpm_parallel_item

  # Test zpm info
  local info_output="$(zpm-info @zpm)"
  assert_match 'Plugin:' "$info_output" 'zpm-info outputs plugin name'
  assert_match 'Type:' "$info_output" 'zpm-info outputs plugin type'

  # Test zpm readme
  local readme_output="$(PAGER=cat zpm-readme @zpm)"
  assert_match 'ZPM' "$readme_output" 'zpm-readme outputs README content'

  # Test zpm link for a directory
  local local_plugin_dir="${sandbox}/my-local-plugin"
  mkdir -p "${local_plugin_dir}"
  touch "${local_plugin_dir}/my-local-plugin.plugin.zsh"
  local link_output="$(zpm-link "${local_plugin_dir}")"
  assert_match 'Linked and loaded plugin' "$link_output" 'zpm-link links local plugin directory'

  # Test zpm dispatcher with info and list
  local list_output="$(zpm list)"
  assert_match 'Plugin:' "$list_output" 'zpm list dispatches to zpm-info'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
