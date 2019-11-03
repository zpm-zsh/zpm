#!/usr/bin/env zsh

if [[ -f ~/.zpm-cache.zsh ]]; then
  source ~/.zpm-cache.zsh
else
  source ${${(%):-%x}:a:h}/lib/functions.zsh
  source ${${(%):-%x}:a:h}/lib/core.zsh
  source ${${(%):-%x}:a:h}/lib/initialize.zsh
  
  source ${${(%):-%x}:a:h}/lib/imperative.zsh
fi

function _post_fn () {
  TMOUT=5
  source ${${(%):-%x}:a:h}/lib/completion.zsh
}

TMOUT=1

add-zsh-hook background _post_fn
