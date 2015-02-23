#!/usr/bin/env zsh

setopt autocd

alias cd/="cd /"
alias tmp='cd $(mktemp -d)'
alias cdo='cd $OLDPWD'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
