#!/usr/bin/env zsh

_ZPM-install-from-GitHub(){
  declare -a spin
  spin=('◐' '◓' '◑' '◒') 
  local Plugin_path=$(_ZPM-get-path $1)
  local Plugin_name=$(_ZPM-get-name $1)

  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!

  if [[ $COLORS=="true" ]]; then
    echo -en "$fg[green]Installing$fg[cyan] ${1} ${fg[green]}from ${fg[blue]}GitHub  ${fg[yellow]}${spin[0]}"
  else
    echo -en "Installing ${1} from GitHub  ${spin[0]}"
  fi

  while $( kill -0 $pid 2>/dev/null)
  do
    for i in "${spin[@]}"
    do
      echo -ne "\b$i"
      sleep 0.2
    done
  done
  echo -e "\b✓"

}

_ZPM-install-plugin(){
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    _ZPM-install-from-GitHub $1
  fi
}
