#!/usr/bin/env zsh

{
  for file in  ~/.zshrc \
  ${_ZPM_DIR}/**/*.zsh \
  ${_ZPM_PLUGIN_DIR}/**/*.zsh \
  ${_ZPM_PLUGIN_DIR}/**/*.zsh-theme ; do
    if [[ -f ${file} && ( ! -s ${file}.zwc || ${file} -nt ${file}.zwc) ]]; then
      zcompile $file
    fi
  done
} &!
