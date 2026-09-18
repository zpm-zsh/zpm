#!/usr/bin/env zsh

# Mirrors how zsh-syntax-highlighting 0.8.x locates itself: it overwrites $0
# unconditionally, so anything the plugin manager assigned beforehand is lost.
0=${(%):-%N}

typeset -g ZPM_SELFLOC_DIR="${0:A:h}"
typeset -g ZPM_SELFLOC_X="${${(%):-%x}:A:h}"
typeset -g ZPM_SELFLOC_ZERO="$ZERO"
