#!/usr/bin/env zsh

setopt autocd              # Auto changes to a directory without typing cd.
setopt autopushd           # Push the old directory onto the stack on cd.
setopt pushdignoredups    # Do not store duplicates in the stack.
setopt pushdsilent         # Do not print the directory stack after pushd or popd.
setopt pushdtohome        # Push to home directory when no argument is given.
setopt cdablevars          # Change directory to a path stored in a variable.


alias d='dirs -v'
for index ({0..9}) alias "$index"="cd +${index}"; unset index

alias tmp='cd $(mktemp -d)'
alias cdo='cd -'
alias -- -='cd -'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
