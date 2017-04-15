#!/usr/bin/env zsh


source ${${(%):-%x}:a:h}/lib/core.zsh

source ${${(%):-%x}:a:h}/lib/functions.zsh

source ${${(%):-%x}:a:h}/lib/install.zsh

source ${${(%):-%x}:a:h}/lib/initialize.zsh

source ${${(%):-%x}:a:h}/lib/upgrade.zsh

source ${${(%):-%x}:a:h}/lib/compile.zsh

function ZPM(){
  for plugin ($@); do
    _ZPM-initialize-plugin $plugin
  done
}

function Plug(){
  echo This function depricated, change Plug to ZPM
  ZPM $@
}

