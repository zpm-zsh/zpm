#!/usr/bin/env zsh

if [[ -z "$COLORS" ]]; then
  export COLORS=true
fi

if [[ -z "$DEBUG" ]]; then
  export DEBUG="false"
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

if [[ "$COLORS" == "true" ]]; then
  autoload -U colors && colors
  export TERM="xterm-256color"
  export CLICOLOR=1
fi

if [[ -z "$ZPM_DIR" ]]; then
  _ZPM_DIR="$(realpath ${${(%):-%x}:a:h}/..)"
else
  _ZPM_DIR="$ZPM_DIR"
  unset ZPM_DIR
fi

if [[ -z "${ZPM_PLUGIN_DIR}" ]]; then
  _ZPM_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zpm"
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
autoload -U compinit && compinit
zmodload zsh/terminfo

mkdir -p "$_ZPM_PLUGIN_DIR"
