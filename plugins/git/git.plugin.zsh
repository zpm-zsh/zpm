#!/usr/bin/env zsh

GIT_PREFIX=${GIT_PREFIX:-' '}
GIT_SUFIX=${GIT_SUFIX:-''}

GIT_NOT_COMMITED=${GIT_NOT_COMMITED:-'▸'}
GIT_CONFLICT=${GIT_CONFLICT:-'x'}
GIT_CHANGED=${GIT_CHANGED:-'+'}
GIT_UNTRACKED=${GIT_UNTRACKED:-'+'}
GIT_CLEAN=${GIT_CLEAN:-'●'}
GIT_PUSH=${GIT_PUSH:-'↑'}
GIT_PULL=${GIT_PULL:-'↓'}


gitstatus_path=${${(%):-%x}:a:h}/gitstatus.py


_git_prompt() {
  if [ "$(command git config --get --bool oh-my-zsh.hide-status 2>/dev/null)" != "true" ] \
  && git rev-parse --git-dir > /dev/null 2>&1; then
    git_vars=$(GIT_PUSH="$GIT_PUSH" GIT_PULL="$GIT_PULL" python3 $gitstatus_path 2>/dev/null)
    git_vars=("${(@f)git_vars}")
    if [[ "$git_vars[7]" == 1 ]]; then
      if [[ $COLORS == "true" ]]; then
        clean="%{$fg[yellow]%}$GIT_CLEAN"
      else
        clean="$GIT_CLEAN"
      fi
    else
      if [[ $COLORS == "true" ]]; then
        clean="%{$fg[red]%}$GIT_CLEAN"
      else
        clean="$GIT_CLEAN"
      fi
    fi
    if [[ $COLORS == "true" ]]; then
      branch="%{$fg[green]%} $git_vars[1]"
    else
      branch=" $git_vars[1]"
    fi
    
    if [ -n "$git_vars[2]" ]; then
      if [[ $COLORS == "true" ]]; then
        remote=" %{$fg[yellow]%}$git_vars[2]"
      else
        remote=" $git_vars[2]"
      fi
    else
      remote=""
    fi
    if [[ $git_vars[3] ==  "0" ]]; then
      staged=""
    else
      if [[ $COLORS == "true" ]]; then
        staged=" %{$fg[cyan]%}$GIT_NOT_COMMITED$git_vars[3]"
      else
        staged=" $GIT_NOT_COMMITED$git_vars[3]"
      fi
    fi
    if [[ "$git_vars[4]" == "0" ]]; then
      conflicts=""
    else
      if [[ $COLORS == "true" ]]; then
        conflicts=" %{$fg[red]%}$GIT_CONFLICT$git_vars[4]"
      else
        conflicts=" $GIT_CONFLICT$git_vars[4]"
      fi
    fi
    if [[ "$git_vars[5]" == 0 ]]; then
      changed=""
    else
      if [[ $COLORS == "true" ]]; then
        changed=" %{$fg[red]%}$GIT_CHANGED$git_vars[5]"
      else
        changed=" $GIT_CHANGED$git_vars[5]"
      fi
    fi
    if [[ "$git_vars[6]" == 0 ]]; then
      untracked=""
    else
      if [[ $COLORS == "true" ]]; then
        untracked=" %{$fg[magenta]%}$GIT_UNTRACKED$git_vars[6]"
      else
        untracked=" $GIT_UNTRACKED$git_vars[6]"
      fi
    fi
    gitprompt=""
    gitprompt+="$GIT_PREFIX"
    gitprompt+=$clean
    gitprompt+=$branch
    gitprompt+=$remote
    gitprompt+=$conflicts
    gitprompt+=$untracked
    gitprompt+=$staged
    gitprompt+=$changed
    if [[ $COLORS == "true" ]]; then
      gitprompt+="%{$reset_color%}"
    fi
    gitprompt+=$GIT_SUFIX
  else
    gitprompt=""
  fi
}

chpwd_functions+=(_git_prompt)
periodic_functions+=(_git_prompt)
