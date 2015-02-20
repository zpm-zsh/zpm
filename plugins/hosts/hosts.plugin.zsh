#!/usr/bin/etc zsh

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


zstyle ':completion:*:(ssh|scp|sshfs):*' tag-order '! users'
zstyle ':completion:*:(ssh|scp|sshfs):*' sort false

zstyle ':completion:*:hosts' hosts $hosts 



