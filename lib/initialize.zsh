#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()

function _ZPM-load-plugin() {
  local Plugin_path
  local Plugin_name
  
  Plugin_base=$(_ZPM-get-plugin-base "$1")
  Plugin_path=$(_ZPM-get-plugin-path "$1")
  Plugin_name=$(_ZPM-get-plugin-basename "$1")
  
  if [[ "$1"  == *",fpath-only"* ]]; then
    if [[ "$1"  == *",fpath-only:"* ]]; then
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}$(echo "$1" | awk -F'fpath-only:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM-appendfpath "${Plugin_path}$(echo "$1" | awk -F'fpath-only:' '{print $2}' | awk -F',' '{print $1}')"
      return 0
    fi
    _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}"
    _ZPM-appendfpath "$Plugin_path"
    return 0
  fi
  
  if [[ "$1"  == *",bin-only"* ]]; then
    if [[ "$1"  == *",bin-only:"* ]]; then
      _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}$(echo "$1" | awk -F'bin-only:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM-appendpath "${Plugin_path}$(echo "$1" | awk -F'bin-only:' '{print $2}' | awk -F',' '{print $1}')"
      return 0
    fi
    _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}/bin"
    _ZPM-appendpath "${Plugin_path}/bin"
    return 0
  fi
  
  if [[ "$1"  == *",fpath"* ]]; then
    if [[ "$1"  == *",fpath:"* ]]; then
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}$(echo "$1" | awk -F'fpath:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM-appendfpath "${Plugin_path}$(echo "$1" | awk -F'fpath:' '{print $2}' | awk -F',' '{print $1}')"
    else
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}"
      _ZPM-appendfpath "$Plugin_path"
    fi
  else
    if [[ $(echo "${Plugin_path}/_"*) != "${Plugin_path}/_*" ]]; then
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}"
      _ZPM-appendfpath "$Plugin_path"
    fi
  fi
  
  if [[ "$1"  == *",bin:"* ]]; then
    _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}$(echo "$1" | awk -F'bin:' '{print $2}' | awk -F',' '{print $1}')"
    _ZPM-appendpath "${Plugin_path}$(echo "$1" | awk -F'bin:' '{print $2}' | awk -F',' '{print $1}')"
  else
    if [[ -d ${Plugin_path}/bin ]]; then
      _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}/bin"
      _ZPM-appendpath "${Plugin_path}/bin"
    fi
  fi
  
  if [[ -f "${Plugin_path}/${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${Plugin_base}"
    source "${Plugin_path}/${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${Plugin_base}"
    source "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh" ]]; then
    _ZPM-log zpm:init:source "Source ${Plugin_base}"
    source "${Plugin_path}/${Plugin_name}.zsh"
  elif [[ -f "${Plugin_path}/${Plugin_name}.zsh-theme" ]]; then
    _ZPM-log zpm:init:source "Source ${Plugin_base}"
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
    xargs -P0 -n1 "${${(%):-%x}:a:h}/../bin/_ZPM-plugin-helper" install
    
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
