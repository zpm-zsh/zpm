#!/usr/bin/env zsh

fpath+=("${0:h}/autoload")

autoload -Uz compinit
local _comp_files=(${HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files

zpm zpm-zsh/helpers zpm-zsh/colors zpm-zsh/background

autoload -Uz _ZPM_Background_Initialization
if [[ -z "$ZPM_NO_ASYNC_HOOK" ]]; then
  TMOUT=1
  add-zsh-hook background _ZPM_Background_Initialization
else
  _ZPM_Background_Initialization
fi
