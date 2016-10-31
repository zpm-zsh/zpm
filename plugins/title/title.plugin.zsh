#!/usr/bin/env zsh

title="%2~"
function _precmd_title(){
  local program=zsh
  if [[ ! -z $TMUX ]]; then
    print -Pn $( eval "echo '\033k'$TITLE'\033\\'")
  else
    print -Pn $( eval "echo '\e]0;'$TITLE'\a'")
  fi
}

function _title(){
  local program=$(echo "$1" | cut -d" " -f1)
  if [[ ! -z $TMUX ]]; then
    print -Pn $( eval "echo '\033k'$TITLE'\033\\'")
  else
    print -Pn $( eval "echo '\e]0;'$TITLE'\a'")
  fi
}

precmd_functions+=(_precmd_title)
preexec_functions+=(_title)
