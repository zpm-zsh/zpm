#!/usr/bin/env zsh

magic-enter () {
  if [[ -z $BUFFER ]]; then
    zle kill-line
  else
    zle accept-line
  fi
}

zle -N magic-enter
bindkey "^M" magic-enter

bindkey "^C" kill-whole-line

# TODO: This is fery beautiful, but provide some problems
# function _pre_noempty(){
#   stty intr "^P"
# }
# 
# function _post_noempty(){
#   stty intr "^C"
# }

precmd_functions+=(_pre_noempty)
preexec_functions+=(_post_noempty)
