#!/usr/bin/env zsh

# Zsh Plugin Standard compatibility
# 0 – the plugin manager provides the ZERO parameter,
# f - … supports the functions subdirectory,
# u - … the unload function,
# U - … the @zsh-plugin-run-on-unload call,
# p – … the @zsh-plugin-run-on-update call,
# i – … the zsh_loaded_plugins activity indicator,
# P – … the ZPFX global parameter,
# s – … the PMSPEC global parameter itself (i.e.: should be always present).
export PMSPEC="0fiPs"

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

fpath+=("${0:h}/functions")

autoload -Uz                     \
  compinit                       \
  _ZPM_addfpath                  \
  _ZPM_addpath                   \
  _ZPM_Background_Initialization \
  _ZPM_clean                     \
  _ZPM_compile                   \
  _ZPM_get_plugin_basename       \
  _ZPM_get_plugin_file_path      \
  _ZPM_get_plugin_link           \
  _ZPM_get_plugin_name           \
  _ZPM_get_plugin_path           \
  _ZPM_get_plugin_type           \
  _ZPM_initialize_plugin         \
  _ZPM_load_plugin               \
  _ZPM_log                       \
  _ZPM_upgrade                   \
