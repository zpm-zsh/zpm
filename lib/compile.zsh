#!/usr/bin/env zsh

{
  setopt +o nomatch
  autoload -Uz zrecompile
  zrecompile -q -p \
                    -R ~/.zshrc -- \
                    -M ~/.zcompdump -- \
                    ~/.zshcache.zwc ${_ZPM_DIR}/**/*.zsh ${_ZPM_PLUGIN_DIR}/**/*.zsh ${_ZPM_PLUGIN_DIR}/**/*.zsh-theme 2>/dev/null
} &!
