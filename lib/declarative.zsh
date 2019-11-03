#!/usr/bin/env zsh

function zpm(){
  if [[ "$1" == 'c' || "$1" == 'cl' || "$1" == 'clean' ]]; then
    shift
    _ZPM_clean
    return 0
  fi
  
  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM-upgrade "$@"
    return 0
  fi
  
  if [[ "$1" == 'load' ]]; then
    shift
  fi
  
  if [[ "$1" == 'load-if' || "$1" == 'if' ]]; then
    if check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi
  
  if [[ "$1" == 'load-if-not' || "$1" == 'if-not' ]]; then
    if ! check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi
  
  _ZPM-initialize-plugin "$@"
}
