#!/usr/bin/env zsh

export _ZPM_DIR=${ZPM_DIR:-"$HOME/.zpm"}
export _ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}

typeset -ag zsh_loaded_plugins

export ZPFX="${HOME}/.local"

_ZPM_CACHE="${TMPDIR:-/tmp}/zsh-${UID}/cache/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${TMPDIR:-/tmp}/zsh-${UID}/cache/zpm-cache-async.zsh"

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/functions.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
  eval "$(<${_ZPM_DIR}/lib/completion.zsh)"
fi
