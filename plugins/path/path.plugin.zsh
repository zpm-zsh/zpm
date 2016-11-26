#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

path() {
  echo $PATH | tr ":" "\n" | awk "{ sub(\"/usr\",\"$fg_no_bold[green]/usr$reset_color\"); sub(\"/bin\",\"$fg_no_bold[cyan]/bin$reset_color\"); sub(\"/games\",\"$fg_no_bold[magenta]/games$reset_color\"); sub(\"/opt\",\"$fg_no_bold[cyan]/opt$reset_color\"); sub(\"/sbin\",\"$fg_no_bold[magenta]/sbin$reset_color\"); sub(\"/local\",\"$fg_no_bold[yellow]/local$reset_color\"); print }"
}

p() {
  pa=$(pwd)
  pa=${pa//\//$fg[red]\/$fg[cyan]}
  pa=$fg[cyan]$pa
  echo $pa
}

_current_path() {
  if [[ -z "$TMUX" ]]; then
    newPWD=$(print -Pn %3~)
    newHOME=$(echo $HOME | sed 's/\//\\\//g')
    newPWD=$(echo $newPWD| sed 's/^'$newHOME'/~/g')
    if [[ $COLORS == "true" ]]; then
      newPWD=${newPWD//\//%{$fg[red]%}\/%{$fg[cyan]%}}
      current_path="$CURRENT_PATH_PREFIX%{$fg[cyan]%}$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
    else
      current_path="$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX"
    fi
  fi
}

chpwd_functions+=(_current_path)

[[ -d ~/.bin ]] && PATH=$PATH:~/.bin
[[ -d ~/.local/bin ]] && PATH=$PATH:~/.local/bin
