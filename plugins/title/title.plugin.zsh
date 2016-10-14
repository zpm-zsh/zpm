#!/usr/bin/env zsh

title="%n@%m: %2~"

function _title(){
  print -Pn $( eval "echo '\e]0;'$TITLE'\a'")
}

precmd_functions+=(_title)






