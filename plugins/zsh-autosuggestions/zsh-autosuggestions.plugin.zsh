#!/usr/bin/env zsh

source ${0:a:h}/zsh-autosuggestions/autosuggestions.zsh

zle-line-init() {
zle autosuggest-start
}
zle -N zle-line-init
