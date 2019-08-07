#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()

function _ZPM-load-plugin() {
  local Plugin_path
  local Plugin_name
  
  Plugin_path=$(_ZPM-get-plugin-path "$1")
  Plugin_name=$(_ZPM-get-plugin-basename "$1")
  
  if [[ ! -d $Plugin_path ]]; then
    _ZPM-install-plugin "$1"
  fi
  
  _ZPM-log zpm:init "Add to FPATH ${Plugin_path}"
  _ZPM-appendfpath "$Plugin_path"
  
  if [[ -d ${Plugin_path}/bin ]]; then
    _ZPM-log zpm:init "Add to PATH ${Plugin_path}/bin"
    _ZPM-appendpath "${Plugin_path}/bin"
  fi
  
  if [[ -f "${Plugin_path}/${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init "Source ${Plugin_path}/${Plugin_name}.plugin.zsh"
    source "${Plugin_path}/${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init "Source ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
    source "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh" ]]; then
    _ZPM-log zpm:init "Source ${Plugin_path}/${Plugin_name}.zsh"
    source "${Plugin_path}/${Plugin_name}.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh-theme" ]]; then
    _ZPM-log zpm:init "Source ${Plugin_path}/${Plugin_name}.zsh-theme"
    source "${Plugin_path}/${Plugin_name}.zsh-theme"
  fi
}

function _ZPM-initialize-plugin() {
  if [[ ! " ${_ZPM_Plugins[*]} " == *"$1"* ]]; then
    _ZPM-log zpm:init "Initialize $1"
    
    _ZPM_Plugins+=("$1")
    _ZPM-load-plugin "$1"
  else
    _ZPM-log zpm:init "Skip initialization $1"
  fi
}
