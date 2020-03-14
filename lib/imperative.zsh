#!/usr/bin/env zsh

compinit -i -C -d "${ZPM_COMPDUMP}"

zpm zpm-zsh/helpers zpm-zsh/colors zpm-zsh/background

if [[ -z "$ZPM_NO_ASYNC_HOOK" ]]; then
  TMOUT=1
  add-zsh-hook background _ZPM_Background_Initialization
else
  _ZPM_Background_Initialization
fi
