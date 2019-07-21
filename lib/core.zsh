#!/usr/bin/env zsh

: ${CLICOLOR:=1}
: ${SHELL:="$(command -v zsh)"}
: ${PERIOD:=10}

export CLICOLOR
export SHELL

HISTSIZE=9999
SAVEHIST=9999
LISTMAX=9999
WORDCHARS='*?_[]~=&;!#$%^(){}<>:.'
HISTFILE="$HOME/.zsh_history"
ZSH_COMPDUMP="$HOME/.zcompdump"

if [[ -z "$ZPM_DIR" ]]; then
  _ZPM_DIR="${${(%):-%x}:a:h}/.."
  _ZPM_DIR="${_ZPM_DIR:A}"
else
  _ZPM_DIR="$ZPM_DIR"
  unset ZPM_DIR
fi

if [[ -z "${ZPM_PLUGIN_DIR}" ]]; then
  _ZPM_PLUGIN_DIR="$HOME/.local/lib/zpm"
else
  _ZPM_PLUGIN_DIR="${ZPM_PLUGIN_DIR}"
  unset ZPM_PLUGIN_DIR
fi

_ZPM-appendfpath "$_ZPM_DIR"

# Some modules
setopt prompt_subst
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "$HOME/.cache/zsh"

autoload -Uz compinit
compinit
autoload -U add-zsh-hook

function _ZPM_Post_Initialization(){
  compinit;
  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

add-zsh-hook precmd _ZPM_Post_Initialization

mkdir -p "$_ZPM_PLUGIN_DIR"
