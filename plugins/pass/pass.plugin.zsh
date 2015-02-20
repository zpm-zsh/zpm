#!/usr/bin/env zsh

zstyle ':completion:*:*:pass:*' verbose yes
zstyle ':completion:*:*:pass:*:descriptions' format '%F{red}%U%B%d%b%u'
zstyle ':completion:*:*:pass:*' ignored-patterns '_*'


zstyle ':completion:*:*:pass:*' group-name ''
