#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
_ZPM_DIR=${0:h}

export _ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}
export ZPFX="${HOME}/.local"

typeset -ag zsh_loaded_plugins

_ZPM_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID}"
_ZPM_CACHE="${_ZPM_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${_ZPM_CACHE_DIR}/zpm-cache-async.zsh"

if [[ -f "${_ZPM_CACHE}" && -z "$ZPM_NO_CACHE"  ]]; then
  source "${_ZPM_CACHE}"
  return
fi

eval "$(<${_ZPM_DIR}/lib/functions.zsh)"
eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
eval "$(<${_ZPM_DIR}/lib/completion.zsh)"
