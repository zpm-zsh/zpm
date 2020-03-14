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

ZPM_COMPDUMP="${_ZPM_CACHE_DIR}/zcompdump"

fpath+=("${_ZPM_DIR}/functions")

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
  _ZPM_get_plugin_hyperlink      \
  _ZPM_get_plugin_name           \
  _ZPM_get_plugin_path           \
  _ZPM_get_plugin_type           \
  _ZPM_initialize_plugin         \
  _ZPM_load_plugin               \
  _ZPM_log                       \
  _ZPM_upgrade

