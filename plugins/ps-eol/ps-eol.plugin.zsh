#!/usr/bin/env zsh

if [[ "$COLORS" == "true" ]]; then
  ps_eol="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
else
  ps_eol="⏎"
fi
