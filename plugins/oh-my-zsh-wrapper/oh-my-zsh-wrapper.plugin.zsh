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
    compinit
    precmd_functions=(${precmd_functions#_oh_my_zsh_apply})
}

function _oh-my-zsh-wrapper-update-hook(){
	echo ">> Updating hook: oh-my-zsh"
    git --git-dir="$HOME/.oh-my-zsh/.git/" --work-tree="$HOME/.oh-my-zsh/" pull

}

precmd_functions+=( _oh_my_zsh_apply )
