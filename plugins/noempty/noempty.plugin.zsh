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

