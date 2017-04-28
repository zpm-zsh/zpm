#!/usr/bin/env zsh

{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump" 1>/dev/null  2>/dev/nul
  fi

  find ${_ZPM_DIR}/ -type f -name "*.zsh" | while read file; do
    zcompile $file 1>/dev/null  2>/dev/nul
  done

  find ${_ZPM_PLUGIN_DIR}/ -type f -name "*.zsh" | while read file; do
    zcompile $file 1>/dev/null  2>/dev/nul
  done

} &!
