#!/usr/bin/env zsh

_zpm_completions_plugins_upgradable=(zpm)
for plugin in $_ZPM_Plugins; do
  local unused=${plugin//:/\\:}
  _zpm_completions_plugins_upgradable+=( $unused )
done

_zpm_completions_plugins_local=()
for plugin in "$_ZPM_PLUGIN_DIR/"*; do
  local unused=${plugin:t}
  _zpm_completions_plugins_local+=( ${unused//---/\/} )
done

_zpm_completions_plugins_loaded=()
for plugin ($_ZPM_Plugins); do
  _zpm_completions_plugins_loaded+=( $(_ZPM-get-plugin-name "$plugin") )
done

_zpm_completions_plugins_loadable=($(
    echo ${_zpm_completions_plugins_local[@]} ${_zpm_completions_plugins_loaded[@]} |\
    tr ' ' '\n' | sort | uniq -u
))

_zpm_completions_1st_arguments=(
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_zpm_completions_1st_arguments_full=(
  'clean:Remove zpm cache'
  'upgrade:Upgrade plugin'
  'load:Load plugin'
  'if:Load plugin if condition true'
  'if-not:Load plugin if condition false'
)

_zpm_completions_if_args=(
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
    _describe -t commands "zpm subcommand" _zpm_completions_1st_arguments_full
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
      _describe -t commands "zpm plugins" _zpm_completions_plugins_upgradable
    elif [[                          \
        "$words[$PRE]" == "if"     ||\
        "$words[$PRE]" == "if-not"   \
      ]];then
      _describe -t commands "zpm condition" _zpm_completions_if_args
    elif ((${words[(I)load]})); then
      _describe -t commands "zpm load" _zpm_completions_plugins_loadable
    else
      _describe -t commands "zpm subcommand" _zpm_completions_1st_arguments
    fi
  fi
}

compdef _zpm zpm
