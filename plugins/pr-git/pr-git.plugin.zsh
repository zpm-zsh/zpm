#!/usr/bin/env zsh

GIT_PREFIX=${GIT_PREFIX:-' '}
GIT_SUFIX=${GIT_SUFIX:-''}

GIT_SYMBOL=${GIT_SYMBOL:-''}



_git-info() {
  changes=$(git status --porcelain | head -1 2>/dev/null)
  ref=$(command git symbolic-ref HEAD 2>/dev/null)
  if [[ $CLICOLOR = 1 ]]; then
    
    if [ ! -z "$changes" ]; then
      git_status="%{$fg_bold[red]%}$GIT_SYMBOL%{$reset_color%}"
    else
      git_status="%{$fg_bold[green]%}$GIT_SYMBOL%{$reset_color%}"
    fi
    
  else
    
    if [ ! -z "$changes" ]; then
      git_status="-$GIT_SYMBOL"
    else
      git_status="+$GIT_SYMBOL"
    fi
    
  fi
  if [[ $CLICOLOR = 1 ]]; then

  git_branch="%{$fg_bold[yellow]%}${ref#refs/heads/}%{$reset_color%}"
  else
  git_branch="${ref#refs/heads/}"

  fi

  echo "$git_status $git_branch"
  
}

_git_prompt() {
  if [ "$(command git config --get --bool oh-my-zsh.hide-status 2>/dev/null)" != "true" ] \
  && _ZPM-recursive-exist .git > /dev/null 2>&1; then
    pr_git="$GIT_PREFIX$(_git-info)$GIT_SUFIX"
  else
    pr_git=""
  fi
}

precmd_functions+=(_git_prompt)
