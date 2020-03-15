#!/usr/bin/env zsh

# Zsh Plugin Standard compatibility
# 0 – the plugin manager provides the ZERO parameter,
# f - … supports the functions subdirectory,
# f - … supports the bin subdirectory,
# u - … the unload function,
# U - … the @zsh-plugin-run-on-unload call,
# p – … the @zsh-plugin-run-on-update call,
# i – … the zsh_loaded_plugins activity indicator,
# P – … the ZPFX global parameter,
# s – … the PMSPEC global parameter itself (i.e.: should be always present).
export PMSPEC="0fbiPs"

export ZPFX="${HOME}/.local"

declare -ag zsh_loaded_plugins

ZPM_COMPDUMP="${_ZPM_CACHE_DIR}/zcompdump"

autoload -Uz compinit


