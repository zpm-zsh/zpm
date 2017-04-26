#!/usr/bin/env zsh

if (( $+commands[dircolors] )); then
  eval $(dircolors ${${(%):-%x}:a:h}/dircolors )
else
  if (( $+commands[gdircolors] )); then
    eval $(gdircolors ${${(%):-%x}:a:h}/dircolors )
  fi
  
fi

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
