#!/usr/bin/env zsh

function _ZPM-install-from-GitHub(){
  declare -a spin
  spin=('◐' '◓' '◑' '◒')
  local Plugin_path=$(_ZPM-plugin-path $1)
  local Plugin_name=$(_ZPM-plugin-name $1)

  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!

  if [[ "$CLICOLOR" = 1 ]]; then
    echo -en "$fg[green]Installing $fg[cyan]"
    echo -en $'\033]8;;https://github.com/'"$1"$'\a'
    echo -en "${1//\//$fg[red]/$fg[cyan]}"
    echo -en $'\033]8;;\a'
    echo -en "${fg[yellow]}  ${spin[0]}${reset_color}"
  else
    echo -en "Installing ${1} from GitHub  ${spin[0]}"
  fi

  while $( kill -0 $pid 2>/dev/null)
  do
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

}

function _ZPM-install-plugin(){
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    _ZPM-install-from-GitHub $1
  fi
}
