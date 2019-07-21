#!/usr/bin/env zsh

function _ZPM-install-from-GitHub(){
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  
  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!
  
  install_string=""
  
  if [[ "$CLICOLOR" = 1 ]]; then
    install_string+="[1m[32mInstalling[0m "
    install_string+=$'\033]8;;https://github.com/'"$1"$'\a'
    install_string+="[1m[34m${1//\//[1m[31m/[1m[34m}"
    install_string+=$'\033]8;;\a'
    install_string+="[0m"
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
