#!/usr/bin/env zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone --recursive https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
fi

export ZSH=$HOME/.oh-my-zsh

function _oh_my_zsh_apply(){

    for plugin ($plugins); do
        if [ -f ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh ]; then
            source ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh
        fi
    done

    for plugin ($plugins); do
        fpath=(~/.oh-my-zsh/plugins/$plugin $fpath)
    done

}

function _oh-my-zsh-update-hook(){

    _oh_my_zsh_old_path="$PWD"
    cd ~/.oh-my-zsh
    echo ">> Updating hook: Oh-my-zsh"
    git pull
    cd $_oh_my_zsh_old_path

}

_ZPM_update_hooks=( $_ZPM_update_hooks _oh-my-zsh-update-hook )

_ZPM_End_hooks=( $_ZPM_End_hooks _oh_my_zsh_apply )
