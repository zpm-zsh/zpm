#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()
_ZPM_Plugins_3rdparty=()
_ZPM_Plugins_core=()

function _ZPM-load-plugin() {

  local Plugin_path=$(_ZPM-plugin-path $1)
  local Plugin_name=$(_ZPM-plugin-name $1)

  if [[ ! -d $Plugin_path ]]; then
    _ZPM-install-plugin $1
  fi

  if  _ZPM-if-fpath-not-empty ${Plugin_path} ; then
    FPATH="$FPATH:${Plugin_path}"
  fi

  if [[ -d ${Plugin_path}/bin ]]; then
    PATH="$PATH:${Plugin_path}/bin"
  fi

  if [[ -f ${Plugin_path}/${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/${Plugin_name}.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.zsh
  fi
}

function _ZPM-initialize-plugin() {
  _ZPM_Plugins+=($1)
  if [[ $(_ZPM-plugin-type $1) == 'core' ]]; then
    _ZPM_Plugins_core+=($1)
  else
    _ZPM_Plugins_3rdparty+=($1)
  fi

  _ZPM-load-plugin $1
}

function _ZPM-init() {
  compinit
  precmd_functions=(${precmd_functions#_ZPM-init})
}
precmd_functions+=(_ZPM-init)
