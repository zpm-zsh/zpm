#!/usr/bin/env zsh

if [[ "$CLICOLOR" = 1 ]]; then
  pr_eol="%{$bg[cyan]%}%{$fg_bold[white]%}⏎%{$reset_color%}"
else
  pr_eol="⏎"
fi
