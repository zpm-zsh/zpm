#!/usr/bin/env zsh

if [[ -z "$CLICOLOR" ]]; then
  CLICOLOR=1
fi

if [[ -z "$EDITOR" ]]; then
  EDITOR="vim"
fi

if [[ -z "$VISUAL" ]]; then
  VISUAL="vim"
fi

if [[ -z "$PAGER" ]]; then
  PAGER="less"
fi

if [[ -z "$SHELL" ]]; then
  SHELL="$(command -v zsh)"
fi

if [[ -z "$PERIOD" ]]; then
  PERIOD=10
fi

if [[ "$CLICOLOR" = 1 ]]; then
  autoload -U colors && colors
  TERM="xterm-256color"
fi

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

export CLICOLOR
export EDITOR
export VISUAL
export PAGER
export PERIOD
export TERM
export SHELL

export FPATH=$FPATH:$_ZPM_DIR
export ZSH_COMPDUMP="$HOME/.zcompdump"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=9999
export SAVEHIST=9999
export WORDCHARS="*?_-~=&;!#$%^()[]{}<>:."
export LISTMAX=9999

# Some modules
setopt prompt_subst
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "$HOME/.cache/zsh"

autoload -Uz compinit 
compinit
autoload -U add-zsh-hook

function _ZPM_Post_Initialization(){
  	compinit;
    precmd_functions=(${precmd_functions#_ZPM_Post_Initialization})
}

precmd_functions+=(_ZPM_Post_Initialization)

mkdir -p "$_ZPM_PLUGIN_DIR"
