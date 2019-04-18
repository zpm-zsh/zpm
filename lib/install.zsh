#!/usr/bin/env zsh

function _ZPM-install-from-GitHub(){
  declare -a spin_color
  declare -a spin_no_color
  spin_color=('◐' '◓' '◑' '◒')
  spin_no_color=('-' '\' '|' '/')
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  
  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!
  
  if [[ "$CLICOLOR" = 1 ]]; then
    
    echo -en "$fg_bold[green]Installing "
    echo -en $'\033]8;;https://github.com/'"$1"$'\a'
    echo -en "$fg_bold[blue]${fg[blue]}${1//\//$fg[red]/$fg[blue]}${fg[blue]}"
    echo -en $'\033]8;;\a'
    echo -en "${fg_bold[yellow]}  ${spin_color[0]}${reset_color}"
    
    while $( kill -0 $pid 2>/dev/null); do
      for i in "${spin_color[@]}"; do
        echo -en "\b${fg[yellow]}${i}${reset_color}"
        sleep 0.2
      done
    done
    echo -e "\b${fg[yellow]}✓${reset_color}"
    
  else
    
    echo -en "Installing ${1} from GitHub  ${spin_no_color[0]}"

    while $( kill -0 $pid 2>/dev/null); do
      for i in "${spin_no_color[@]}"; do
        echo -en "\b${i}"
        sleep 0.2
      done
    done
    echo -e "\b✓"
    
  fi
  
}

function _ZPM-install-plugin(){
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    _ZPM-install-from-GitHub $1
  fi
}
