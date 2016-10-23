#!/usr/bin/env zsh

function _eol(){
  if [[ "$COLORS" == "true" ]]; then
    eol="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
  else
    eol="⏎"
  fi
}

precmd_functions+=(_eol)
