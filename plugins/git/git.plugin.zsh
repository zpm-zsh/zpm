#!/usr/bin/env zsh

GIT_PREFIX=${GIT_PREFIX:-' '}
GIT_SUFIX=${GIT_SUFIX:-''}

if [[ $COLORS == "true" ]]; then
  GIT_PREFIX=${GIT_PREFIX:-"%{$reset_color%}"}
  GIT_SUFIX=${GIT_SUFIX:-"%{$reset_color%}"}

  GIT_CLEAN_START=${GIT_CLEAN_START:-"%{$fg[yellow]%}"}
  GIT_CLEAN_END=${GIT_CLEAN_END:-"%{$fg[yellow]%}"}
  GIT_DIRTY_START=${GIT_DIRTY_START:-"%{$fg[red]%}"}
  GIT_DIRTY_END=${GIT_DIRTY_END:-"%{$fg[red]%}"}
  GIT_NOT_COMMITED=${GIT_NOT_COMMITED:-"%{$fg[green]%}▸"}
  GIT_CONFLICT=${GIT_CONFLICT:-"%{$fg[yellow]%}x"}
  GIT_CHANGED=${GIT_CHANGED:-"%{$fg[cyan]%}+"}
  GIT_UNTRACKED=${GIT_UNTRACKED:-"%{$fg[red]%}+"}
  GIT_PUSH=${GIT_PUSH:-"%{$fg[red]%}↑"}
  GIT_PULL=${GIT_PULL:-"%{$fg[yellow]%}↓"}
else
  GIT_PREFIX=${GIT_PREFIX:-' '}
  GIT_SUFIX=${GIT_SUFIX:-''}

  GIT_CLEAN_START=${GIT_CLEAN_START:-''}
  GIT_CLEAN_END=${GIT_CLEAN_END:-''}
  GIT_DIRTY_START=${GIT_DIRTY_START:-''}
  GIT_DIRTY_END=${GIT_DIRTY_END:-''}
  GIT_NOT_COMMITED=${GIT_NOT_COMMITED:-'▸'}
  GIT_CONFLICT=${GIT_CONFLICT:-'x'}
  GIT_CHANGED=${GIT_CHANGED:-'+'}
  GIT_UNTRACKED=${GIT_UNTRACKED:-'+'}
  GIT_PUSH=${GIT_PUSH:-'↑'}
  GIT_PULL=${GIT_PULL:-'↓'}
fi


gitstatus_path=${${(%):-%x}:a:h}/gitstatus.py


_git_prompt() {
  if [ "$(command git config --get --bool oh-my-zsh.hide-status 2>/dev/null)" != "true" ] \
  && git rev-parse --git-dir > /dev/null 2>&1; then
    git_vars=$(GIT_PUSH="$GIT_PUSH" GIT_PULL="$GIT_PULL" python3 $gitstatus_path 2>/dev/null)
    git_vars=("${(@f)git_vars}")


    if [[ "$git_vars[7]" == 1 ]]; then
      branch="${GIT_CLEAN_START}$git_vars[1]${GIT_DIRTY_END}"
    else
      branch="${GIT_DIRTY_START}$git_vars[1]${GIT_DIRTY_END}"
    fi

    if [ -n "$git_vars[2]" ]; then
      remote=" $git_vars[2]"
    else
      remote=""
    fi

    if [[ $git_vars[3] ==  "0" ]]; then
      staged=""
    else
      staged=" ${GIT_NOT_COMMITED}$git_vars[3]"
    fi

    if [[ "$git_vars[4]" == "0" ]]; then
      conflicts=""
    else
      conflicts=" ${GIT_CONFLICT}$git_vars[4]"
    fi

    if [[ "$git_vars[5]" == 0 ]]; then
      changed=""
    else
      changed=" ${GIT_CHANGED}$git_vars[5]"
    fi

    if [[ "$git_vars[6]" == 0 ]]; then
      untracked=""
    else
      untracked=" ${GIT_UNTRACKED}$git_vars[6]"
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
    gitprompt+=$GIT_SUFIX
  else
    gitprompt=""
  fi
}

precmd_functions+=(_git_prompt)
