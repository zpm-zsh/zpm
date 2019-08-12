#!/usr/bin/env zsh

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins )
  else
    _Plugins_Upgrade+=($@)
  fi
  
  printf '%s\n' "${_Plugins_Upgrade[@]}" | xargs -P8 -I {} "${${(%):-%x}:a:h}/../bin/_ZPM-helper" upgrade {}

  return 0
}
