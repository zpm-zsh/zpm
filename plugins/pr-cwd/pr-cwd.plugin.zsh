#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

_pr_cwd_HOME_=$(echo $HOME | sed 's/\//\\\//g')

_pr_cwd() {
  
  local newPWD=$(print -Pn %2~)
  newPWD=$(echo $newPWD| sed 's/^'$_pr_cwd_HOME_'/~/g')
  
  local lockIcon=""
  if [[ ! -w "$PWD" ]]; then
    lockIcon=" "
  fi
  
  if [[ $CLICOLOR = 1 ]]; then
    newPWD=${newPWD//\//%{$fg_bold[red]%}\/%{$fg_bold[blue]%}}
    newPWD=$'%{\033]8;;file://'"$PWD"$'\a%}'$newPWD$'%{\033]8;;\a%}'
    pr_cwd="$CURRENT_PATH_PREFIX%{$fg[red]%}$lockIcon%{$fg_bold[blue]%}$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
  else
    pr_cwd="$CURRENT_PATH_PREFIX$lockIcon$newPWD$CURRENT_PATH_SUFIX"
  fi
  
}

_pr_cwd
chpwd_functions+=(_pr_cwd)
