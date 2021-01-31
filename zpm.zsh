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
export PMSPEC="0fbPs"
export ZPFX="${HOME}/.local"

export _ZPM_DIR="${${(%):-%x}:h}"
export _ZPM_PLUGIN_DIR="${_ZPM_DIR}/plugins"

export ZSH_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID:-user}"
_ZPM_CACHE="${ZSH_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${ZSH_CACHE_DIR}/zpm-cache-async.zsh"
_ZPM_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump"

fpath+=("${_ZPM_DIR}/functions" "${ZSH_CACHE_DIR}/functions")
export PATH="$PATH:${ZSH_CACHE_DIR}/bin"
typeset -aU path cdpath fpath manpath

autoload -Uz compinit
zstyle ':completion:*:zpm:*' sort false

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/init.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
fi
