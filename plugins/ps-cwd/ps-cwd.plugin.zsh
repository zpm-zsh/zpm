#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

_PS_CWD_HOME_=$(echo $HOME | sed 's/\//\\\//g')

_ps_cwd() {
  local newPWD=$(print -Pn %2~)
  local newPWD=$(echo $newPWD| sed 's/^'$_PS_CWD_HOME_'/~/g')
  if [[ $COLORS == "true" ]]; then
    newPWD=${newPWD//\//%{$fg[red]%}\/%{$fg[cyan]%}}
    ps_cwd="$CURRENT_PATH_PREFIX%{$fg[cyan]%}$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
  else
    ps_cwd="$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX"
  fi
}
_ps_cwd
chpwd_functions+=(_ps_cwd)
