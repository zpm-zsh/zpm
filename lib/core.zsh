#!/usr/bin/env zsh

SHELL=zsh
HISTSIZE=9999
SAVEHIST=9999
LISTMAX=9999
HISTFILE="$HOME/.zsh_history"
ZSH_COMPDUMP="$HOME/.zcompdump"
PERIOD=10

_ZPM_DIR=${ZPM_DIR:-"${${(%):-%x}:a:h}/.."}
_ZPM_DIR="${_ZPM_DIR:A}"
export _ZPM_DIR
unset ZPM_DIR

_ZPM_PLUGIN_DIR=${ZPM_PLUGIN_DIR:-"$HOME/.local/lib/zpm"}
_ZPM_PLUGIN_DIR="${_ZPM_PLUGIN_DIR:A}"
export _ZPM_PLUGIN_DIR
unset ZPM_PLUGIN_DIR

# Some modules
unsetopt BG_NICE
setopt prompt_subst
setopt +o nomatch

zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "$HOME/.cache/zsh"

autoload -Uz compinit
compinit

function _ZPM_Post_Initialization(){
  compinit
  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ZPM_Post_Initialization

mkdir -p "$_ZPM_PLUGIN_DIR"
zpm zpm-zsh/helpers zpm-zsh/colors
