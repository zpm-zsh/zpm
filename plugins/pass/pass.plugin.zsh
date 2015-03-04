#!/usr/bin/env zsh

zstyle ':completion:*:*:pass:*' verbose yes
zstyle ':completion:*:*:pass:*:descriptions' format '%F{red}%U%d%u%f'
zstyle ':completion:*:*:pass:*' ignored-patterns '_*'


zstyle ':completion:*:*:pass:*' group-name ''
