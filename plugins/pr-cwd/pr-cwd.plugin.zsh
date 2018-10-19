#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

_pr_cwd_HOME_=$(echo $HOME | sed 's/\//\\\//g')

_pr_cwd() {
  local newPWD=$(print -Pn %2~)
  local newPWD=$(echo $newPWD| sed 's/^'$_pr_cwd_HOME_'/~/g')
  if [[ $COLORS == "true" ]]; then
    newPWD=${newPWD//\//%{$fg[red]%}\/%{$fg[cyan]%}}
    pr_cwd="$CURRENT_PATH_PREFIX%{$fg[cyan]%}$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
  else
    pr_cwd="$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX"
  fi
}
_pr_cwd
chpwd_functions+=(_pr_cwd)
