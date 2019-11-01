#!/usr/bin/env zsh


ZPM_PATH=""
ZPM_fpath=()

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

function _ZPM_Post_Initialization(){
  post_fn
  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ZPM_Post_Initialization

mkdir -p "$_ZPM_PLUGIN_DIR"

rm "$_ZPM_CACHE" 2>/dev/null
touch "$_ZPM_CACHE"
