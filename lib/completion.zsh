#!/usr/bin/env zsh

_ZPM_Plugins_comp_upgradable=(zpm)
for plugin in $_ZPM_Plugins; do
  local unused=${plugin//:/\\:}
  _ZPM_Plugins_comp_upgradable+=( $unused )
done

_ZPM_Plugins_comp_local=()
for plugin in "$_ZPM_PLUGIN_DIR/"*; do
  local unused=${plugin:t}
  _ZPM_Plugins_comp_local+=( ${unused//---/\/} )
done

_ZPM_Plugins_comp_loaded=()
for plugin ($_ZPM_Plugins); do
  _ZPM_Plugins_comp_loaded+=( $(_ZPM-get-plugin-name "$plugin") )
done

_ZPM_Plugins_comp_loadable=($(
    echo ${_ZPM_Plugins_comp_local[@]} ${_ZPM_Plugins_comp_loaded[@]} |\
    tr ' ' '\n' | sort | uniq -u
))

_zpm_1st_arguments=(
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_1st_arguments_full=(
  'clean:Remove zpm cache'
  'upgrade:Upgrade plugin'
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_zpm_if_args=(
  'linux'
  'bsd'
  'macos'
  'android'
  'termux'
  'ssh'
  'tmux'
)

_zpm(){
  
  _arguments \
  '*:: :->subcmds' && return 0
  
  if (( CURRENT == 1 )); then
    _describe -t commands "zpm subcommand" _1st_arguments_full
    return
  fi
  
  if [[ "$words[1]" == 'clean' ]]; then
    return
  fi
  
  if (( CURRENT > 1 )); then
    PRE=$((CURRENT - 1))
    
    if [[                            \
        "$words[$PRE]" == "u"      ||\
        "$words[$PRE]" == "up"     ||\
        "$words[$PRE]" == "upgrade"  \
      ]]; then
      _describe -t commands "zpm plugins" _ZPM_Plugins_comp_upgradable
    elif [[                          \
        "$words[$PRE]" == "if"     ||\
        "$words[$PRE]" == "if-not"   \
      ]];then
      _describe -t commands "zpm condition" _zpm_if_args
    elif ((${words[(I)load]})); then
      _describe -t commands "zpm load" _ZPM_Plugins_comp_loadable
    else
      _describe -t commands "zpm subcommand" _zpm_1st_arguments
    fi
  fi
}

compdef _zpm zpm
