#!/usr/bin/env zsh

function _ZPM-install-from-GitHub(){
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  
  git clone --recursive "https://github.com/"${1}".git" "$Plugin_path" </dev/null >/dev/null 2>/dev/null &!
  pid=$!
  
  local install_string=""
  
  install_string+="${c[green]}${c_bold}Installing${c_reset} "
  install_string+=$'\033]8;;https://github.com/'"$1"$'\a'
  install_string+="${c[blue]}${c_bold}${1//\//${c[red]}${c_bold}/${c[blue]}${c_bold}}"
  install_string+=$'\033]8;;\a'
  install_string+="${c_reset}"
  
  _ZPM-spinner-for-backgroud-process $install_string $pid
  
}

function _ZPM-install-plugin(){
  _ZPM-log zpm:install:try "Try to install ${1}"
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    _ZPM-log zpm:install:github "Install ${1} form GiHub"
    _ZPM-install-from-GitHub $1
  fi
}
