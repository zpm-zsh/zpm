#!/usr/bin/env zsh


_ZPM_Plugins_installed=()
for plugin in "$_ZPM_PLUGIN_DIR/"*; do
  local unused=${plugin:t}
  _ZPM_Plugins_installed+=${unused//---/\/}
done

_ZPM_Plugins_upgradable=()
for plugin ($_ZPM_Plugins); do
  _ZPM_Plugins_upgradable+=($(_ZPM-get-plugin-name "$plugin"))
done

_ZPM_Plugins_loadable=($(
    echo ${_ZPM_Plugins_installed[@]} ${_ZPM_Plugins_upgradable[@]} |\
    tr ' ' '\n' | sort | uniq -u
))

_1st_arguments=(
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_1st_arguments_full=(
  'upgrade:Upgrade plugin'
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_ZPM_if_args=(
  'linux'
  'bsd'
  'macos'
  'android'
  'termux'
  'ssh'
  'tmux'
)

_zpm(){
  _ZPM_Plugins_upgradable+=("zpm")
  
  _arguments \
  '*:: :->subcmds' && return 0
  
  if (( CURRENT == 1 )); then
    _describe -t commands "zpm subcommand" _1st_arguments_full
    return
  fi
  
  if (( CURRENT > 1 )); then
    PRE=$((CURRENT - 1))
    
    if [[                            \
        "$words[$PRE]" == "u"      ||\
        "$words[$PRE]" == "up"     ||\
        "$words[$PRE]" == "upgrade"  \
      ]]; then
      _describe -t commands "zpm plugins" _ZPM_Plugins_installed
    elif [[                          \
        "$words[$PRE]" == "if"     ||\
        "$words[$PRE]" == "if-not"   \
      ]];then
      _describe -t commands "zpm condition" _ZPM_if_args
    elif ((${words[(I)load]})); then
      _describe -t commands "zpm load" _ZPM_Plugins_loadable
    else
      _describe -t commands "zpm subcommand" _1st_arguments
    fi
  fi
}

compdef _zpm zpm
