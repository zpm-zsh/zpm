#!/usr/bin/env zsh

function zpm(){
  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM-upgrade $@
    return 0
  fi
  
  if [[ "$1" == 'load' ]]; then
    shift
  fi
  
  if [[ "$1" == 'load-if' ]]; then
    if check-if "$2"; then
      shift 2
    else
      return 0
    fi
  fi
  
  if [[ "$1" == 'load-if-not' ]]; then
    if ! check-if "$2"; then
      shift 2
    else
      return 0
    fi
  fi
  
  for plugin ($@); do
    _ZPM-initialize-plugin $plugin
  done
}

zpm zpm-zsh/helpers zpm-zsh/colors zpm-zsh/figures
