#!/usr/bin/env zsh

if [[ "$COLORS" == "true" ]]; then
  pr_eol="%{$bg[cyan]%}%{$fg_bold[white]%}⏎%{$reset_color%}"
else
  pr_eol="⏎"
fi
