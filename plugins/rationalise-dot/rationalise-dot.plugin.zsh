#!/usr/bin/env zsh

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]
  then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
