#!/usr/bin/env zsh

function _ps2(){
  ps2="%{$fg[green]%}%_>%{$reset_color%}"
}

precmd_functions+=(_ps2)
