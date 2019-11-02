#!/usr/bin/env zsh


ZPM_PATH=""
ZPM_fpath=()
ZPM_files_for_source=()
ZPM_files_for_async_source=()

_ZPM_DIR=${ZPM_DIR:-"${${(%):-%x}:a:h}/.."}
_ZPM_DIR="${_ZPM_DIR:A}"
export _ZPM_DIR
unset ZPM_DIR

_ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}
_ZPM_PLUGIN_DIR="${_ZPM_PLUGIN_DIR:A}"
export _ZPM_PLUGIN_DIR
unset ZPM_PLUGIN_DIR

_ZPM_CACHE=${ZPM_CACHE:-"$HOME/.zpm-cache.zsh"}
_ZPM_CACHE="${_ZPM_CACHE:A}"
export _ZPM_CACHE
unset ZPM_CACHE
