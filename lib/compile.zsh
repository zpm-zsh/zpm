#!/usr/bin/env zsh

{
  autoload -Uz zrecompile
  zrecompile "~/.zshrc" "${HOME}/.zcompdump" ${_ZPM_DIR}/**/*.zsh ${_ZPM_PLUGIN_DIR}/**/*.zsh
} &!
