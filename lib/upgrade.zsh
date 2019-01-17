#!/usr/bin/env zsh

function _ZPM-upgrade-plugin(){
  _ZPM-log $1 $2
  declare -a spin
  spin=('◐' '◓' '◑' '◒')

  git --git-dir="${2}/.git/" --work-tree="${2}/" checkout "${2}/" </dev/null >/dev/null 2>/dev/null &!
  git --git-dir="${2}/.git/" --work-tree="${2}/" pull </dev/null >/dev/null 2>/dev/null  &!
  pid=$!

  local update_info=""

  if [[ "$CLICOLOR" = 1 ]]; then
    update_info+="${fg[green]}Updating ${fg[cyan]}"
    if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
      update_info+=$'\033]8;;https://github.com/'"$1"$'\a'
    else
      update_info+=$'\033]8;;file://'"$2"$'\a'
    fi
    update_info+="${1//\//$fg[red]/$fg[cyan]}"
    update_info+=$'\033]8;;\a'
    update_info+="${fg[yellow]}  ${spin[0]}${reset_color}"
  else
    update_info+="Updating ${1}  ${spin[0]}"
  fi
  echo -en ${update_info}

  while $(kill -0 $pid 2>/dev/null); do
    for i in "${spin[@]}"
    do
      [[ "$CLICOLOR" = 1 ]] && \
      echo -en "\b${fg[yellow]}${i}${reset_color}" || \
      echo -en "\b${i}"
      sleep 0.2
    done
  done
  [[ "$CLICOLOR" = 1 ]] && \
  echo -e "\b${fg[yellow]}✓${reset_color}" || \
  echo -e "\b✓"

  for i ($_ZPM_Core_Plugins); do
    type _${i}-upgrade | grep -q "shell function" && _${i}-upgrade >/dev/null 2>/dev/null &!
  done

}

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins_3rdparty )
  else
    _Plugins_Upgrade+=($@)
  fi

  for i ($_Plugins_Upgrade); do
    _ZPM-upgrade-plugin $i $(_ZPM-plugin-path $i)
  done
  return 0
}
