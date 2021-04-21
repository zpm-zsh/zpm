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
export ZSH_CUSTOM="${${(%):-%x}:h}"

export ZSH_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID:-user}"
_ZPM_CACHE="${ZSH_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${ZSH_CACHE_DIR}/zpm-cache-async.zsh"
_ZPM_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump"

fpath=("${ZSH_CUSTOM}/functions" "${ZSH_CACHE_DIR}/functions" $fpath)
export PATH="${ZSH_CACHE_DIR}/bin:$PATH"
typeset -aU path cdpath fpath manpath

autoload -Uz compinit
zstyle ':completion:*:zpm:*' sort false

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${ZSH_CUSTOM}/lib/init.zsh)"
  eval "$(<${ZSH_CUSTOM}/lib/imperative.zsh)"
fi
