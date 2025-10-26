#!/usr/bin/env zsh
# Zsh Plugin Standard compatibility
# 0 – the plugin manager provides the ZERO parameter,
# f - … supports the functions subdirectory,
# b - … supports the bin subdirectory,
# u - … the unload function,
# U - … the @zsh-plugin-run-on-unload call,
# p – … the @zsh-plugin-run-on-update call,
# i – … the zsh_loaded_plugins activity indicator,
# P – … the ZPFX global parameter,
# s – … the PMSPEC global parameter itself (i.e.: should be always present).
export PMSPEC="0fbs"

0="${${(M)0:#/*}:-$PWD/$0}"
typeset -gr _ZPM_DIR="${0:h}"
export _ZPM_DIR

export ZSH_TMP_DIR="${ZSH_TMP_DIR:-${TMPDIR:-/tmp}/zsh-${UID:-user}}"
typeset -g _ZPM_CACHE="${ZSH_TMP_DIR}/zpm-cache.zsh"
typeset -g _ZPM_CACHE_ASYNC="${ZSH_TMP_DIR}/zpm-cache-async.zsh"

export ZSH_DATA_HOME="${ZSH_DATA_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh}"
typeset -g _ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
typeset -g _ZPM_PLUGIN_DIR="${_ZPM_PLUGINS_DIR}/zpm"

export ZSH_CACHE_HOME="${ZSH_CACHE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
typeset -g _ZPM_COMPDUMP="${ZSH_CACHE_HOME}/zcompdump-${ZSH_VERSION}"

typeset -gaU path fpath
fpath=("${_ZPM_DIR}/functions" "${ZSH_TMP_DIR}/functions" "${fpath[@]}")
path=("${ZSH_TMP_DIR}/bin" "${path[@]}")
export PATH

autoload -Uz -- compinit

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  source "${_ZPM_DIR}/lib/init.zsh"
  source "${_ZPM_DIR}/lib/imperative.zsh"
fi
