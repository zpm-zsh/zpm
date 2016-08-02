#!/usr/bin/env zsh

DEPENDENCES_ARCH+=(xclip)
DEPENDENCES_DEBIAN+=(xclip)

if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias open='cygstart'
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias open='xdg-open'
  alias o='xdg-open'
  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  fi
fi
