#!/usr/bin/env zsh

mkdir -p "${ZSH_CACHE_DIR}" "${ZSH_CACHE_DIR}/functions" "${ZSH_CACHE_DIR}/bin"

compinit -i -C -d "${_ZPM_COMPDUMP}"

declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
@zpm-load-plugins zpm-zsh/helpers

sched +1 @zpm-background-initialization

function source() {
  if [[ ! "${1}.zwc" -nt "${1}" ]]; then
    zcompile "${1}" 2>/dev/null
  fi

  builtin source "$1"
}
