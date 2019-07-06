#!/usr/bin/env zsh

function _ZPM-upgrade-plugin(){
  _ZPM-log $1
  declare -a spin_color
  declare -a spin_no_color
  spin_color=('◐' '◓' '◑' '◒')
  spin_no_color=('-' '\' '|' '/')
  
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  local Plugin_url=$(_ZPM-get-plugin-url $1)
  
  
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" checkout "${Plugin_path}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${Plugin_path}/.git/" --work-tree="${Plugin_path}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!
  
  
  if [[ "$CLICOLOR" = 1 ]]; then

    echo -en "${fg_bold[green]}Updating "
    echo -en $'\033]8;;'"$Plugin_url"$'\a'
    echo -en "$fg_bold[blue]${1//\//$fg_bold[red]/$fg_bold[blue]}"
    echo -en $'\033]8;;\a'
    echo -en "${fg_bold[yellow]}  ${spin_color[0]}${reset_color}"
    
    while $(kill -0 $pid 2>/dev/null); do
      for i in "${spin_color[@]}"
      do
        echo -en "\b${fg_bold[yellow]}${i}${reset_color}"
        sleep 0.2
      done
    done
    
    echo -e "\b${fg_bold[green]}✓${reset_color}"
    
  else
  
    echo -en "Updating ${1}  ${spin_no_color[0]}"
    
    while $(kill -0 $pid 2>/dev/null); do
      for i in "${spin_no_color[@]}"
      do
        echo -en "\b${i}"
        sleep 0.2
      done
    done
    
    echo -e "\b+"
    
  fi  
  
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
