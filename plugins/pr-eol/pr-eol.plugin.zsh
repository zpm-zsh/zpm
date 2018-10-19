#!/usr/bin/env zsh

if [[ "$COLORS" == "true" ]]; then
  pr_eol="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
else
  pr_eol="⏎"
fi
