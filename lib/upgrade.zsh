#!/usr/bin/env zsh

function _ZPM-upgrade-plugin(){
  _ZPM-log zpm:upgrade "Upgrade ${1}"
  
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  local Plugin_url=$(_ZPM-get-plugin-url $1)
  
  
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" checkout "${Plugin_path}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!
  
  
  local upgrade_string=""
  
  upgrade_string+="${c[green]}${c_bold}Updating${c_reset} "
  upgrade_string+=$'\033]8;;'"$Plugin_url"$'\a'
  upgrade_string+="${c[blue]}${c_bold}${1//\//${c[red]}${c_bold}/${c[blue]}${c_bold}}"
  upgrade_string+=$'\033]8;;\a'
  upgrade_string+="${c_reset}"
  
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
