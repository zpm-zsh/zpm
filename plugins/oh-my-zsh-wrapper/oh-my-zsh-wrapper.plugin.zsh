#!/usr/bin/env zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone --recursive https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
fi

export ZSH=$HOME/.oh-my-zsh

for plugin ($plugins); do
    if [ -f ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh ]; then
        source ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh
    fi
done

for plugin ($plugins); do
    fpath=(~/.oh-my-zsh/plugins/$plugin $fpath)
done

unset ZSH
