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
export _ZPM_DIR="${0:h}"

export ZSH_TMP_DIR="${ZSH_TMP_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/zpm}"
_ZPM_CACHE="${ZSH_TMP_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${ZSH_TMP_DIR}/zpm-cache-async.zsh"

export ZSH_DATA_HOME="${ZSH_DATA_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh}"
_ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
_ZPM_PLUGIN_DIR="${ZSH_DATA_HOME}/plugins/zpm"

export ZSH_CACHE_HOME="${ZSH_CACHE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
_ZPM_COMPDUMP="${ZSH_CACHE_HOME}/zcompdump-${ZSH_VERSION}"

fpath=("${_ZPM_DIR}/functions" "${ZSH_TMP_DIR}/functions" $fpath)
export PATH="${ZSH_TMP_DIR}/bin:$PATH"
typeset -gaU path fpath

autoload -Uz compinit

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/init.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
fi
