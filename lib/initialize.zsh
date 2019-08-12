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
  
  _ZPM-log zpm:init:fpath "Add to FPATH ${1}"
  _ZPM-appendfpath "$Plugin_path"
  
  if [[ -d ${Plugin_path}/bin ]]; then
    _ZPM-log zpm:init:path "Add to PATH ${1}/bin"
    _ZPM-appendpath "${Plugin_path}/bin"
  fi
  
  if [[ -f "${Plugin_path}/${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${1}"
    source "${Plugin_path}/${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${1}"
    source "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${1}"
    source "${Plugin_path}/${Plugin_name}.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh-theme" ]]; then
    _ZPM-log zpm:init:source "Source ${1}"
    source "${Plugin_path}/${Plugin_name}.zsh-theme"
  fi
}

function _ZPM-initialize-plugin() {
  # Check if plugin isn't loaded
  declare -a _Plugins_Install
  
  for plugin ($@); do
    
    Plugin_path=$(_ZPM-get-plugin-path "$plugin")
    
    if [[ ! -d $Plugin_path ]]; then
      _Plugins_Install+=("$plugin")
    fi
    
  done
  
  
  if [[ -n "$_Plugins_Install[@]" ]]; then;
    
    printf '%s\n' "${_Plugins_Install[@]}" | \
    xargs -P8 -n1 "${${(%):-%x}:a:h}/../bin/_ZPM-plugin-helper" install
    
  fi
  
  for plugin ($@); do
    
    if [[ " ${_ZPM_Plugins[*]} " != *"$plugin"* ]]; then
      _ZPM-log zpm:init "Initialize $plugin"
      
      _ZPM_Plugins+=("$plugin")
      _ZPM-load-plugin "$plugin"
    else
      _ZPM-log zpm:init:skip "Skip initialization $1"
    fi

  done
}
