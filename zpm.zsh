#!/usr/bin/env zsh

_ZPM_PATH=""
_ZPM_fpath=()

typeset -a zsh_loaded_plugins
typeset -A _ZPM_plugins_full
_ZPM_plugins_full["zpm"]="zpm"

typeset -a _ZPM_plugins_for_source
typeset -a _ZPM_plugins_for_async_source
typeset -a _ZPM_plugins_no_source

typeset -A _ZPM_file_for_source
typeset -A _ZPM_file_for_async_source

export ZPFX="${HOME}/.local"

_ZPM_DIR=${ZPM_DIR:-"${${(%):-%x}:A:h}"}
export _ZPM_DIR
unset ZPM_DIR

_ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}
_ZPM_PLUGIN_DIR="${_ZPM_PLUGIN_DIR:A}"
export _ZPM_PLUGIN_DIR
unset ZPM_PLUGIN_DIR

_ZPM_CACHE=${ZPM_CACHE:-"${TMPDIR:-/tmp}/.zpm-cache-${USER}.zsh"}
_ZPM_CACHE="${_ZPM_CACHE:A}"
export _ZPM_CACHE
unset ZPM_CACHE

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  source "${_ZPM_DIR}/lib/functions.zsh"
  source "${_ZPM_DIR}/lib/initialize.zsh"
  source "${_ZPM_DIR}/lib/imperative.zsh"
fi
