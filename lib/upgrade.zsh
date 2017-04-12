#!/usr/bin/env zsh

function _ZPM-upgrade(){
  declare -a spin
  spin=('◐' '◓' '◑' '◒') 

  git --git-dir="${2}/.git/" --work-tree="${2}/" checkout "${2}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${2}/.git/" --work-tree="${2}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!

  local update_info=""

  if [[ $COLORS=="true" ]]; then
    update_info+="${fg[green]}Updating ${fg[cyan]}${1//\//$fg[red]/$fg[cyan]}${fg[yellow]}  ${spin[0]}"
  else
    update_info+="Updating ${1}  ${spin[0]}"
  fi
  echo -en ${update_info}

  while $(kill -0 $pid 2>/dev/null); do
    for i in "${spin[@]}"
    do
      echo -ne "\b$i"
      sleep 0.2
    done
  done
  echo -e "\b✓${reset_color}"

  for i ($_ZPM_Core_Plugins); do
    type _${i}-upgrade | grep -q "shell function" && _${i}-upgrade >/dev/null 2>/dev/null &!
  done

}



function ZPM-upgrade(){
  local _Plugins_Upgrade=()

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "ZPM" $_ZPM_Plugins_3rdparty )
  else
    _Plugins_Upgrade+=($@)
  fi

  for i ($_Plugins_Upgrade); do
    if [[ "$i" == "ZPM" ]]; then
      _ZPM-upgrade "ZPM" $_ZPM_DIR
    else
      _ZPM-upgrade $i $(_ZPM-plugin-path $i) 
    fi
  done
  return 0
}

function _ZPM-upgrade-compl(){
  _ZPM_Hooks=( "$_ZPM_GitHub_Plugins" )
  for plugg ($_ZPM_Core_Plugins); do
    if type _$plugg-upgrade | grep "shell function" >/dev/null; then
      _ZPM_Hooks+=($plugg)
    fi
  done
  _arguments "*: :($(echo "ZPM"; echo $_ZPM_Plugins_3rdparty))"
}

compdef _ZPM-upgrade-compl ZPM-upgrade
