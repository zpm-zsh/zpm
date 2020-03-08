#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
_ZPM_DIR=${0:h}
fpath+=("${0:h}/autoload")

export ZPFX="${HOME}/.local"

export _ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}

typeset -ag zsh_loaded_plugins

typeset _ZPM_PATH=""
typeset _ZPM_fpath=()

typeset -A _ZPM_plugins_full
_ZPM_plugins_full[zpm]="zpm"

typeset -a _ZPM_plugins_for_source
typeset -a _ZPM_plugins_for_async_source
typeset -a _ZPM_plugins_no_source

typeset -A _ZPM_file_for_source
typeset -A _ZPM_file_for_async_source

_ZPM_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID}"
_ZPM_CACHE="${_ZPM_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${_ZPM_CACHE_DIR}/zpm-cache-async.zsh"

if [[ -f "${_ZPM_CACHE}" && -z "$ZPM_NO_CACHE"  ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/functions.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
  eval "$(<${_ZPM_DIR}/lib/completion.zsh)"
fi