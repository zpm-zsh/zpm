#!/usr/bin/env zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone --recursive https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh </dev/null >/dev/null 2>/dev/null 
fi

function _oh-my-zsh-wrapper-upgrade(){
  git --git-dir="$HOME/.oh-my-zsh/.git/" --work-tree="$HOME/.oh-my-zsh/" pull </dev/null >/dev/null 2>/dev/null 
}

