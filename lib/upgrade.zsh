#!/usr/bin/env zsh

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins )
  else
    _Plugins_Upgrade+=($@)
  fi
  
  printf '%s\0' "${_Plugins_Upgrade[@]}" | \
  xargs -0 -P16 -n1 "${${(%):-%x}:a:h}/../bin/_ZPM-plugin-helper" upgrade
  
  for plugin ($@); do
    
    local plugin_basename=$(_ZPM-get-plugin-basename $plugin)
    if type _${plugin_basename}-upgrade >/dev/null 2>/dev/null; then
      _${plugin_basename}-upgrade
    fi
    
  done
  
}
