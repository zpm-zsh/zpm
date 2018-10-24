#!/usr/bin/env zsh

GIT_PREFIX=${GIT_PREFIX:-' '}
GIT_SUFIX=${GIT_SUFIX:-''}

GIT_NOT_COMMITED=${GIT_NOT_COMMITED:-'▸'}
GIT_CONFLICT=${GIT_CONFLICT:-'x'}
GIT_CHANGED=${GIT_CHANGED:-'+'}
GIT_UNTRACKED=${GIT_UNTRACKED:-'+'}
GIT_SYMBOL=${GIT_SYMBOL:-'●'}
GIT_PUSH=${GIT_PUSH:-'↑'}
GIT_PULL=${GIT_PULL:-'↓'}


gitstatus_path=${${(%):-%x}:a:h}/gitstatus.py


_git_prompt() {
  if [ "$(command git config --get --bool oh-my-zsh.hide-status 2>/dev/null)" != "true" ] \
  && _ZPM-recursive-exist .git > /dev/null 2>&1; then
    git_vars=$(GIT_PUSH="$GIT_PUSH" GIT_PULL="$GIT_PULL" python3 $gitstatus_path 2>/dev/null)
    git_vars=("${(@f)git_vars}")
    if [[ "$git_vars[7]" == 1 ]]; then
      if [[ $COLORS == "true" ]]; then
        clean="%{$fg_bold[yellow]%}$GIT_SYMBOL"
      else
        clean="$GIT_SYMBOL"
      fi
    else
      if [[ $COLORS == "true" ]]; then
        clean="%{$fg_bold[red]%}$GIT_SYMBOL"
      else
        clean="$GIT_SYMBOL"
      fi
    fi
    if [[ $COLORS == "true" ]]; then
      branch="%{$fg_bold[green]%} $git_vars[1]"
    else
      branch=" $git_vars[1]"
    fi

    if [ -n "$git_vars[2]" ]; then
      if [[ $COLORS == "true" ]]; then
        remote=" %{$fg_bold[yellow]%}$git_vars[2]"
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
        staged=" %{$fg_bold[cyan]%}$GIT_NOT_COMMITED$git_vars[3]"
      else
        staged=" $GIT_NOT_COMMITED$git_vars[3]"
      fi
    fi
    if [[ "$git_vars[4]" == "0" ]]; then
      conflicts=""
    else
      if [[ $COLORS == "true" ]]; then
        conflicts=" %{$fg_bold[red]%}$GIT_CONFLICT$git_vars[4]"
      else
        conflicts=" $GIT_CONFLICT$git_vars[4]"
      fi
    fi
    if [[ "$git_vars[5]" == 0 ]]; then
      changed=""
    else
      if [[ $COLORS == "true" ]]; then
        changed=" %{$fg_bold[red]%}$GIT_CHANGED$git_vars[5]"
      else
        changed=" $GIT_CHANGED$git_vars[5]"
      fi
    fi
    if [[ "$git_vars[6]" == 0 ]]; then
      untracked=""
    else
      if [[ $COLORS == "true" ]]; then
        untracked=" %{$fg_bold[magenta]%}$GIT_UNTRACKED$git_vars[6]"
      else
        untracked=" $GIT_UNTRACKED$git_vars[6]"
      fi
    fi
    pr_git=""
    pr_git+="$GIT_PREFIX"
    pr_git+=$clean
    pr_git+=$branch
    pr_git+=$remote
    pr_git+=$conflicts
    pr_git+=$untracked
    pr_git+=$staged
    pr_git+=$changed
    if [[ $COLORS == "true" ]]; then
      pr_git+="%{$reset_color%}"
    fi
    pr_git+=$GIT_SUFIX
  else
    pr_git=""
  fi
}

precmd_functions+=(_git_prompt)
