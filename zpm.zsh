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
export PMSPEC="0fbiPs"
export ZPFX="${HOME}/.local"

0=${(%):-%x}
export _ZPM_DIR=${0:h}
export _ZPM_PLUGIN_DIR="${0:h}/plugins"

_ZPM_CACHE_DIR="${TMPDIR:-/tmp}/zsh-${UID:-user}"
_ZPM_CACHE="${_ZPM_CACHE_DIR}/zpm-cache.zsh"
_ZPM_CACHE_ASYNC="${_ZPM_CACHE_DIR}/zpm-cache-async.zsh"
_ZPM_COMPDUMP="${_ZPM_CACHE_DIR}/zcompdump"

autoload -Uz compinit
zstyle ':completion:*:zpm:*' sort false

if [[ -f "${_ZPM_CACHE}" ]]; then
  source "${_ZPM_CACHE}"
else
  eval "$(<${_ZPM_DIR}/lib/init.zsh)"
  eval "$(<${_ZPM_DIR}/lib/imperative.zsh)"
fi
