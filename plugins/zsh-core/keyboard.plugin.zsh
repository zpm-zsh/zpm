#!/usr/bin/env zsh

zmodload zsh/complist
 
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[OD' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[OC' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[2~' overwrite-mode
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward
bindkey '^[OB' history-beginning-search-forward

bindkey '^K' clear-screen
bindkey "^W" backward-kill-word
bindkey -M menuselect " " accept-and-menu-complete
