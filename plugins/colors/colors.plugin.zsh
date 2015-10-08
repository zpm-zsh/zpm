#!/usr/bin/env zsh

export GREP_COLOR='4;31'
export PAGER=${PAGER:-"less"}

export LESS_TERMCAP_mb=$'\E[00;32m' 
export LESS_TERMCAP_md=$'\E[00;34m' 
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS='-R -M'
           

export PYGMENTIZE_THEME=${PYGMENTIZE_THEME:-"monokai"}

_pygmentize_theme(){
    if hash pygmentize 2>/dev/null; then
        export LESSOPEN="|pygmentize -f 256 -O style=$PYGMENTIZE_THEME -g %s"
    fi
    alias pygmentize="pygmentize -O style=$PYGMENTIZE_THEME"
    precmd_functions=(${precmd_functions#_pygmentize_theme})

}


precmd_functions+=( _pygmentize_theme )
