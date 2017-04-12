#!/usr/bin/env zsh

{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi

  find ${_ZPM_DIR}/ -type f -name "*.zsh" | while read file; do
    zcompile $file
  done

  find ${_ZPM_PLUGIN_DIR}/ -type f -name "*.zsh" | while read file; do
    zcompile $file
  done

} &!
