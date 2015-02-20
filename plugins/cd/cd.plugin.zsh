#!/usr/bin/env zsh

setopt autocd

alias cd/="cd /"
alias tmp='cd $(mktemp -d)'
alias cdo='cd $OLDPWD'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'


function _showfolder(){

  $(whence ls)

}

chpwd_functions+=( _showfolder )
