#!/usr/bin/env zsh

function _ZPM-upgrade-plugin(){
  _ZPM-log $1
  
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  local Plugin_url=$(_ZPM-get-plugin-url $1)
  
  
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" checkout "${Plugin_path}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!
  
  
  upgrade_string=""
  
  if [[ "$CLICOLOR" = 1 ]]; then
    upgrade_string+="${fg_bold[green]}Updating "
    upgrade_string+=$'\033]8;;'"$Plugin_url"$'\a'
    upgrade_string+="$fg_bold[blue]${1//\//$fg_bold[red]/$fg_bold[blue]}"
    upgrade_string+=$'\033]8;;\a'
    upgrade_string+="${fg_bold[yellow]}"
  else
    upgrade_string+="Updating ${1}"
  fi
  
  _ZPM-spinner-for-backgroud-process $upgrade_string $pid
  
  for i ($_ZPM_Plugins); do
    type _${i}-upgrade | grep -q "shell function" && _${i}-upgrade >/dev/null 2>/dev/null &!
  done
  
}

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins )
  else
    _Plugins_Upgrade+=($@)
  fi
  
  for i ($_Plugins_Upgrade); do
    _ZPM-upgrade-plugin $i
  done
  return 0
}
