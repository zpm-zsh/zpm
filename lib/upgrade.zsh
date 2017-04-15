#!/usr/bin/env zsh

function _ZPM-upgrade(){
  _ZPM-log $1 $2
  declare -a spin
  spin=('◐' '◓' '◑' '◒') 

  git --git-dir="${2}/.git/" --work-tree="${2}/" checkout "${2}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${2}/.git/" --work-tree="${2}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!

  local update_info=""

  if [[ "$COLORS" == "true" ]]; then
    update_info+="${fg[green]}Updating ${fg[cyan]}${1//\//$fg[red]/$fg[cyan]}${fg[yellow]}  ${spin[0]}${reset_color}"
  else
    update_info+="Updating ${1}  ${spin[0]}"
  fi
  echo -en ${update_info}

  while $(kill -0 $pid 2>/dev/null); do
    for i in "${spin[@]}"
    do
      [[ "$COLORS" == "true" ]] && \
      echo -en "\b${fg[yellow]}${i}${reset_color}" || \
      echo -en "\b${i}"
      sleep 0.2
    done
  done
  [[ "$COLORS" == "true" ]] && \
  echo -e "\b${fg[yellow]}✓${reset_color}" || \
  echo -e "\b✓"

  for i ($_ZPM_Core_Plugins); do
    type _${i}-upgrade | grep -q "shell function" && _${i}-upgrade >/dev/null 2>/dev/null &!
  done

}

function ZPM-upgrade(){
  declare -a _Plugins_Upgrade

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins_3rdparty )
  else
    _Plugins_Upgrade+=($@)
  fi

  for i ($_Plugins_Upgrade); do
    _ZPM-upgrade $i $(_ZPM-plugin-path $i) 
  done
  return 0
}
