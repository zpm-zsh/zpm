#!/usr/bin/env zsh

_Install_from_GitHub(){
  declare -a spin
  spin=('◐' '◓' '◑' '◒') 


  if [[ ! -d "$_ZPM_PLUGIN_DIR/$1" ]]; then


    git clone --recursive "https://github.com/"${2}".git" "$_ZPM_PLUGIN_DIR/$1" </dev/null >/dev/null 2>/dev/null &!
    pid=$!

    if [[ $COLORS=="true" ]]; then
      echo -en "$fg[green]Installing$fg[cyan] ${2} ${fg[green]}from ${fg[blue]}GitHub  ${fg[yellow]}${spin[0]}"
    else
      echo -en "Installing ${2} from GitHub  ${spin[0]}"
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

  fi
}