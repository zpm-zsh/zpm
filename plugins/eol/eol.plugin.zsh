#!/usr/bin/env zsh

if [[ "$COLORS" == "true" ]]; then
  eol="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
else
  eol="⏎"
fi

