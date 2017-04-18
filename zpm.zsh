#!/usr/bin/env zsh


source ${${(%):-%x}:a:h}/lib/core.zsh

source ${${(%):-%x}:a:h}/lib/functions.zsh

source ${${(%):-%x}:a:h}/lib/install.zsh

source ${${(%):-%x}:a:h}/lib/initialize.zsh

source ${${(%):-%x}:a:h}/lib/upgrade.zsh

source ${${(%):-%x}:a:h}/lib/compile.zsh

function zpm(){
  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    ZPM-upgrade $@
    return 0
  fi
  if [[ "$1" == 'load' ]]; then
    shift
  fi
  for plugin ($@); do
    _ZPM-initialize-plugin $plugin
  done
}

function Plug(){
  echo 'This function depricated, change `Plug` to `zpm load`'
  zpm $@
}

function ZPM-upgrade(){
  echo 'This function depricated, change `ZPM-upgrade` to `zpm upgrade`'
  _ZPM-upgrade $@
}

