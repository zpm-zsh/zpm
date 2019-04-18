#!/usr/bin/env zsh

if [[ -z "$CLICOLOR" ]]; then
  export CLICOLOR=1
fi

if [[ -z "$EDITOR" ]]; then
  export EDITOR="vim"
fi

if [[ -z "$VISUAL" ]]; then
  export VISUAL="vim"
fi

if [[ -z "$PAGER" ]]; then
  export PAGER="less"
fi

if [[ -z "$SHELL" ]]; then
  export SHELL="$(which zsh)"
fi

if [[ -z "$PERIOD" ]]; then
  export PERIOD=10
fi

if [[ "$CLICOLOR" = 1 ]]; then
  autoload -U colors && colors
  export TERM="xterm-256color"
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



FPATH=$FPATH:$_ZPM_DIR
ZSH_COMPDUMP="$HOME/.zcompdump"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=9999
SAVEHIST=9999
WORDCHARS="*?_-~=&;!#$%^()[]{}<>:."
LISTMAX=9999

# Some modules
setopt prompt_subst
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "$HOME/.cache/zsh"

autoload -Uz compinit 
if [[ -n "${ZSH_COMPDUMP}"(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi


mkdir -p "$_ZPM_PLUGIN_DIR"
