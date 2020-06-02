#!/usr/bin/env zsh

declare -Ag _ZPM_plugins_full=( zpm zpm )
mkdir -p "${_ZPM_CACHE_DIR}" "${_ZPM_CACHE_DIR}/functions"

compinit -i -C -d "${ZPM_COMPDUMP}"

.zpm-initialize-plugins zpm-zsh/helpers zpm-zsh/colors zpm-zsh/background

FPATH="${FPATH}:${_ZPM_CACHE_DIR}/functions"

TMOUT=1
add-zsh-hook background .zpm-background-initialization

function source() {
  if [[ ! "${1}.zwc" -nt "${1}" ]]; then
    zcompile "${1}" 2>/dev/null
  fi

  builtin source "$1"
}
