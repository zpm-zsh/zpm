#!/usr/bin/env zsh

function _eol(){
  eol="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
}

precmd_functions+=(_eol)




