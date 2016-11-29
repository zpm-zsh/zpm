#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

_current_path() {
  newPWD=$(print -Pn %3~)
  newHOME=$(echo $HOME | sed 's/\//\\\//g')
  newPWD=$(echo $newPWD| sed 's/^'$newHOME'/~/g')
  if [[ $COLORS == "true" ]]; then
    newPWD=${newPWD//\//%{$fg[red]%}\/%{$fg[cyan]%}}
    current_path="$CURRENT_PATH_PREFIX%{$fg[cyan]%}$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
  else
    current_path="$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX"
  fi
}
_current_path
chpwd_functions+=(_current_path)

[[ -d ~/.bin ]] && PATH=$PATH:~/.bin
[[ -d ~/.local/bin ]] && PATH=$PATH:~/.local/bin
