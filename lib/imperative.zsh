#!/usr/bin/env zsh
declare -ag _zpm_loaded_plugins
compinit -i -C -d "${_ZPM_COMPDUMP}"

mkdir -p "${_ZPM_CACHE_DIR}" "${_ZPM_CACHE_DIR}/functions" "${_ZPM_CACHE_DIR}/bin"

declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
@zpm-load-plugins zpm-zsh/helpers zpm-zsh/colors zpm-zsh/background

TMOUT=1
add-zsh-hook background @zpm-background-initialization

function source() {
  if [[ ! "${1}.zwc" -nt "${1}" ]]; then
    zcompile "${1}" 2>/dev/null
  fi

  builtin source "$1"
}
