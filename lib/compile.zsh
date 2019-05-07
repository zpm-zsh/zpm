#!/usr/bin/env zsh

{
  setopt +o nomatch
  autoload -Uz zrecompile
  zrecompile -q "~/.zshrc" "${HOME}/.zcompdump" ${_ZPM_DIR}/**/*.zsh ${_ZPM_PLUGIN_DIR}/**/*.zsh ${_ZPM_PLUGIN_DIR}/**/*.zsh-theme
} &!
