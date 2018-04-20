#!/usr/bin/env zsh

setopt autocd

alias tmp='cd $(mktemp -d)'
alias cdo='cd -'
alias -- -='cd -'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
