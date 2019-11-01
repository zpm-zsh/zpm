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
  
  local _ZPM_local_source=true
  local _ZPM_local_async=false
  local _ZPM_local_path=true
  local _ZPM_local_fpath=true
  
  if [[ "$1"  == *",apply:"* ]]; then
    local _ZPM_tag_str=$(echo "$1" | awk -F'apply:' '{print $2}' | awk -F',' '{print $1}')
    
    if $(echo "$_ZPM_tag_str" | grep -v -q 'source' ); then
      _ZPM_local_source=false
    fi
    
    if $(echo "$_ZPM_tag_str" | grep -v -q 'path' ); then
      _ZPM_local_path=false
    fi
    
    if $(echo "$_ZPM_tag_str" | grep -v -q 'fpath' ); then
      _ZPM_local_fpath=false
    fi

    if $(echo "$_ZPM_tag_str" | grep -q 'async' ); then
      _ZPM_local_async=true
    fi


  fi
  

  
  if [[ "$_ZPM_local_fpath"  == "true" ]]; then
    if [[ "$1"  == *",fpath:"* ]]; then
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}/$(echo "$1" | awk -F',fpath:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM-addfpath "${Plugin_path}/$(echo "$1" | awk -F',fpath:' '{print $2}' | awk -F',' '{print $1}')"
    elif test -n "$(find "${Plugin_path}" -maxdepth 1 -name "_*" -print -quit)"; then
      _ZPM-log zpm:init:fpath "Add to FPATH ${Plugin_base}"
      _ZPM-addfpath "${Plugin_path}"
    fi
  fi
  
  if [[ "$_ZPM_local_path"  == "true" ]]; then
    if [[ "$1"  == *",path:"* ]]; then
      _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}/$(echo "$1" | awk -F',path:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM-addpath "${Plugin_path}/$(echo "$1" | awk -F',path:' '{print $2}' | awk -F',' '{print $1}')"
    elif [[ -d ${Plugin_path}/bin ]]; then
      _ZPM-log zpm:init:path "Add to PATH ${Plugin_base}/bin"
      _ZPM-addpath "${Plugin_path}/bin"
    fi
  fi
  
  if [[ "$_ZPM_local_source"  == "true" ]]; then
    if [[ "$1"  == *",source:"* ]]; then
      _ZPM-log zpm:init:path "Source ${Plugin_base}/$(echo "$1" | awk -F',source:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM_source "${Plugin_path}/$(echo "$1" | awk -F',source:' '{print $2}' | awk -F',' '{print $1}')"
    elif [[ -f "${Plugin_path}/${Plugin_name}.plugin.zsh" ]]; then
      _ZPM-log zpm:init:source "Source ${Plugin_base}"
      _ZPM_source "${Plugin_path}/${Plugin_name}.plugin.zsh"
    elif [[ -f "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh" ]]; then
      _ZPM-log zpm:init:source "Source ${Plugin_base}"
      _ZPM_source "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
    elif [[ -f "${Plugin_path}/${Plugin_name}.zsh" ]]; then
      _ZPM-log zpm:init:source "Source ${Plugin_base}"
      _ZPM_source "${Plugin_path}/${Plugin_name}.zsh"
    elif [[ -f "${Plugin_path}/${Plugin_name}.zsh-theme" ]]; then
      _ZPM-log zpm:init:source "Source ${Plugin_base}"
      _ZPM_source "${Plugin_path}/${Plugin_name}.zsh-theme"
    fi
  fi

    
  if [[ "$_ZPM_local_async"  == "true" ]]; then
    if [[ "$1"  == *",source:"* ]]; then
      _ZPM-log zpm:init:async "Async source ${Plugin_base}/$(echo "$1" | awk -F',source:' '{print $2}' | awk -F',' '{print $1}')"
      _ZPM_async_source "${Plugin_path}/$(echo "$1" | awk -F',source:' '{print $2}' | awk -F',' '{print $1}')"
    elif [[ -f "${Plugin_path}/${Plugin_name}.plugin.zsh" ]]; then
      _ZPM-log zpm:init:async "Async source ${Plugin_base}"
      _ZPM_async_source "${Plugin_path}/${Plugin_name}.plugin.zsh"
    elif [[ -f "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh" ]]; then
      _ZPM-log zpm:init:async "Async source ${Plugin_base}"
      _ZPM_async_source "${Plugin_path}/zsh-${Plugin_name}.plugin.zsh"
    elif [[ -f "${Plugin_path}/${Plugin_name}.zsh" ]]; then
      _ZPM-log zpm:init:async "Async source ${Plugin_base}"
      _ZPM_async_source "${Plugin_path}/${Plugin_name}.zsh"
    elif [[ -f "${Plugin_path}/${Plugin_name}.zsh-theme" ]]; then
      _ZPM-log zpm:init:async "Async source ${Plugin_base}"
      _ZPM_async_source "${Plugin_path}/${Plugin_name}.zsh-theme"
    fi
  fi
}

function _ZPM-initialize-plugin() {
  # Check if plugin isn't loaded
  declare -a _Plugins_Install
  
  for plugin ("$@"); do
    local Plugin_path=$(_ZPM-get-plugin-path "$plugin")
    
    if [[ ! -d $Plugin_path ]]; then
      _Plugins_Install+=("$plugin")
    fi
  done
  
  if [[ -n "$_Plugins_Install[@]" ]]; then;
    printf '%s\0' "${_Plugins_Install[@]}" | \
    xargs -0 -P0 -n1 "${${(%):-%x}:a:h}/../bin/_ZPM-plugin-helper" install
  fi
  
  for plugin ($_Plugins_Install); do
    if [[ "$plugin" == *",hook:"* ]]; then
      ${${(%):-%x}:a:h}/../bin/_ZPM-post-install-helper "$plugin"
    fi
  done
  
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
