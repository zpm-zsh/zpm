#!/usr/bin/env zsh

hosts=()
if [ -f ~/.ssh/config ]; then
    hosts=(
        ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
    )
else
    if [ -f ~/.hosts ]; then
        hosts=(
            `cat ~/.hosts `
        )
    fi
fi


zstyle ':completion:*:(ssh|scp|sshfs|mosh):*' tag-order '! users'
zstyle ':completion:*:(ssh|scp|sshfs|mosh):*' sort false

zstyle ':completion:*:hosts' hosts $hosts 



