# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
_ZPM_DIR=${0:h}

export ZPM_USE_CACHE=false

source "${_ZPM_DIR}/../zpm.zsh"
source "${0:h}/lib.zsh"

# --------------------
assert "$zsh_loaded_plugins" contains "zpm-zsh/colors"

# --------------------
zpm load zpm-zsh/empty 
assert "$zsh_loaded_plugins" contains "zpm-zsh/empty"
