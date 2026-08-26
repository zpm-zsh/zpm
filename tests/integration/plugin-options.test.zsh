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

  # Create a fixture plugin with plugin-options.zsh
  local plugin_dir="${_ZPM_PLUGINS_DIR}/@dir---options-pkg"
  mkdir -p "${plugin_dir}"
  cat << 'EOF' > "${plugin_dir}/plugin-options.zsh"
zpm_plugin_async=true
zpm_plugin_autoload="custom_autoload_fn"
EOF
  echo "export OPTIONS_PKG_LOADED=1" > "${plugin_dir}/options-pkg.zsh"

  @zpm-load-plugins '@dir/options-pkg'

  # Check that plugin was routed to async source due to plugin-options.zsh
  local _key='@dir/options-pkg'
  assert_eq "${plugin_dir}/options-pkg.zsh" "${_ZPM_file_for_async_source["$_key"]}" 'plugin-options.zsh async=true routed to async source'
  assert_eq '1' "${#_ZPM_autoload}" 'plugin-options.zsh autoload registered'
  assert_eq 'custom_autoload_fn' "${_ZPM_autoload[1]}" 'correct autoload fn registered'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
