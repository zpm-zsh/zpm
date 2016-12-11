#!/usr/bin/env zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone --recursive https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
fi

function _oh-my-zsh-wrapper-upgrade(){
  echo ">> Updating hook: oh-my-zsh"
  git --git-dir="$HOME/.oh-my-zsh/.git/" --work-tree="$HOME/.oh-my-zsh/" pull
}

