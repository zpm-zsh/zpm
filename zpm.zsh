#!/usr/bin/env zsh

export _ZPM_DIR=${ZPM_DIR:-"$HOME/.zpm"}
export _ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}

typeset -ag zsh_loaded_plugins

export ZPFX="${HOME}/.local"

_ZPM_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID}"
_ZPM_CACHE="${_ZPM_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${_ZPM_CACHE_DIR}/zpm-cache-async.zsh"

if [[ -f "${_ZPM_CACHE}" && "$DEBUG" != "zpm"* ]]; then
  source "${_ZPM_CACHE}"
  return
fi

eval "$(<${_ZPM_DIR}/lib/functions.zsh)"
eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
eval "$(<${_ZPM_DIR}/lib/completion.zsh)"

