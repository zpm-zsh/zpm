#!/usr/bin/env zsh

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;31'
export PAGER=${PAGER:-"less"}

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS='-R -M'
           
if hash pygmentize 2>/dev/null; then
    export LESSOPEN='|pygmentize -f 256 -g %s'
fi
