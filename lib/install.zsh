#!/usr/bin/env zsh

function _ZPM-install-from-GitHub(){
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  
  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!
  
  install_string=""
  
  if [[ "$CLICOLOR" = 1 ]]; then
    install_string+="$fg_bold[green]Installing "
    install_string+=$'\033]8;;https://github.com/'"$1"$'\a'
    install_string+="$fg_bold[blue]${1//\//$fg_bold[red]/$fg_bold[blue]}"
    install_string+=$'\033]8;;\a'
    install_string+="$fg_bold[green] from $fg_bold[cyan]GitHub"
  else
    install_string+="Installing ${1} from GitHub"
  fi
  
  _ZPM-spinner-for-backgroud-process $install_string $pid
  
}

function _ZPM-install-plugin(){
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    _ZPM-install-from-GitHub $1
  fi
}
