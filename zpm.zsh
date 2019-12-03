#!/usr/bin/env zsh

typeset -A _ZPM_plugins_full
_ZPM_plugins_full[zpm]="zpm"

typeset -A _ZPM_file_for_source
typeset -A _ZPM_file_for_async_source

export ZPFX="${HOME}/.local"

_ZPM_DIR=${ZPM_DIR:-"$HOME/.zpm"}
unset ZPM_DIR

_ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}
unset ZPM_PLUGIN_DIR

_ZPM_CACHE="${TMPDIR:-/tmp}/.zpm-cache-${USER}.zsh"
_ZPM_CACHE_ASYNC="${TMPDIR:-/tmp}/.zpm-cache-async-${USER}.zsh"

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  source "${_ZPM_DIR}/lib/functions.zsh"
  source "${_ZPM_DIR}/lib/imperative.zsh"
  source "${_ZPM_DIR}/lib/completion.zsh"
fi
