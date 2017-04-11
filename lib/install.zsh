#!/usr/bin/env zsh

_Install_from_GitHub(){
  if [[ ! -d "$_ZPM_PLUGIN_DIR/$1" ]]; then
    if [[ $COLORS=="true" ]]; then
      echo "$fg[green]Installing$fg[red] ${2} ${fg[green]}from ${fg[blue]}GitHub${reset_color}"
    else
      echo "Installing ${2} from GitHub"
    fi
    git clone --recursive "https://github.com/"${2}".git" "$_ZPM_PLUGIN_DIR/$1" </dev/null >/dev/null 2>/dev/null 
    find "$_ZPM_PLUGIN_DIR/$1" -name "*.zsh" | while read zsh_file; do
    done
  fi
}