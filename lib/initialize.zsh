#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()

function _ZPM-load-plugin() {
  
  local Plugin_path=$(_ZPM-get-plugin-path $1)
  local Plugin_name=$(_ZPM-get-plugin-basename $1)
  
  if [[ ! -d $Plugin_path ]]; then
    _ZPM-install-plugin $1
  fi
  
  _ZPM-log "Add to FPATH ${Plugin_path}"
  FPATH="$FPATH:${Plugin_path}"
  
  if [[ -d ${Plugin_path}/bin ]]; then
  _ZPM-log "Add to PATH ${Plugin_path}/bin"
    PATH="$PATH:${Plugin_path}/bin"
  fi
  
  if [[ -f ${Plugin_path}/${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/${Plugin_name}.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.zsh
  elif [[ -f ${Plugin_path}/${Plugin_name}.zsh-theme ]]; then
    source ${Plugin_path}/${Plugin_name}.zsh-theme
  fi
}

function _ZPM-initialize-plugin() {
  if [[ ! " ${_ZPM_Plugins} " == *"$1"* ]]; then
    _ZPM-log Initialize $1

    _ZPM_Plugins+=($1)
    _ZPM-load-plugin $1
  else
    _ZPM-log Skip initialization $1
  fi
}
