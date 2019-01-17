#!/usr/bin/env zsh

source ${${(%):-%x}:a:h}/lib/functions.zsh

source ${${(%):-%x}:a:h}/lib/core.zsh

source ${${(%):-%x}:a:h}/lib/install.zsh

source ${${(%):-%x}:a:h}/lib/initialize.zsh

source ${${(%):-%x}:a:h}/lib/upgrade.zsh

source ${${(%):-%x}:a:h}/lib/compile.zsh

function zpm(){
  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM-upgrade $@
    return 0
  fi
  if [[ "$1" == 'i' || "$1" == 'l' || "$1" == 'install' || "$1" == 'load' ]]; then
    shift
  fi
  for plugin ($@); do
    _ZPM-initialize-plugin $plugin
  done
}
