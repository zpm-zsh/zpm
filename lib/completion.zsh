#!/usr/bin/env zsh

_zpm(){
  
  local -a _1st_arguments
  _1st_arguments=(
    'upgrade:Upgrade plugin'
    'load:Load plugin'
    'load-if:Load plugin if condition true'
    'load-if-not:Load plugin if condition false'
  )
  
  local -a _ZPM_Plugins_upgradable
  _ZPM_Plugins_upgradable=()
  
  local -a _ZPM_Plugins_installed
  for plugin in "$_ZPM_PLUGIN_DIR/"*---*; do
    local unused=${plugin:t}
    _ZPM_Plugins_installed+=${unused//---/\/}
  done
  
  
  for plugin ($_ZPM_Plugins); do
    
    _ZPM_Plugins_upgradable+=($(_ZPM-get-plugin-base "$plugin"))
    
  done
  
  local -a _ZPM_Plugins_loadable
  _ZPM_Plugins_loadable=($(
      echo ${_ZPM_Plugins_installed[@]} ${_ZPM_Plugins_upgradable[@]} |\
      tr ' ' '\n' | sort | uniq -u
  ))
  
  _ZPM_Plugins_upgradable+=("zpm")
  
  _arguments \
  '*:: :->subcmds' && return 0
  
  if (( CURRENT == 1 )); then
    _describe -t commands "zpm subcommand" _1st_arguments
    return
  fi
  
  if (( CURRENT > 1 )); then
    case "$words[1]" in
      u|up|upgrade)
        _describe -t commands "zpm plugins" _ZPM_Plugins_upgradable
      ;;
      l|load|li|load-if|ln|load-if-not)
        _describe -t commands "zpm plugins" _ZPM_Plugins_loadable
      ;;
    esac
  fi
  
}

compdef _zpm zpm
