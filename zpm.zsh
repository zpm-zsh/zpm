#!/usr/bin/env zsh
0=${(%):-%x}

export _ZPM_DIR=${0:h}
export _ZPM_PLUGIN_DIR="${0:h}/plugins"

_ZPM_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID:-user}"
_ZPM_CACHE="${_ZPM_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${_ZPM_CACHE_DIR}/zpm-cache-async.zsh"

if [[ -f "${_ZPM_CACHE}" && "${ZPM_USE_CACHE}" != 'false' ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/init.zsh)"
  eval "$(<${_ZPM_DIR}/lib/zpm.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
fi
