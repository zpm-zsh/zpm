#!/usr/bin/env zsh

zmodload zsh/complist

bindkey -e

bindkey '^R' history-incremental-search-backward

bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line

bindkey "^[OF"  end-of-line
bindkey "^[[F"  end-of-line

bindkey '^[[1;5C' forward-word
bindkey '^[[C' forward-word

bindkey '^[[1;5D' backward-word
bindkey '^[[D' backward-word

bindkey '^[[C' forward-char
bindkey '^[[D' backward-char

bindkey '^?' backward-delete-char

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey '^[[3;5~' delete-word

bindkey '^H' backward-delete-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey -M menuselect " " accept-and-menu-complete
