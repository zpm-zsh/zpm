#!/usr/bin/env zsh

function _ZPM-log() {
  if [[ ! -z "$DEBUG" ]]; then
    echo $@
  fi
}

function _ZPM-plugin-type() {
  if [[ ${1} == 'zpm' ]]; then
    echo zpm
  elif [[ ${1} == *'/'* ]]; then
    echo github
  else
    echo core
  fi
}

function _ZPM-plugin-path() {
  if [[ $(_ZPM-plugin-type $1) == 'zpm' ]]; then
    echo ${_ZPM_DIR}
  elif [[ $(_ZPM-plugin-type $1) == 'core' ]]; then
    echo "${_ZPM_DIR}/plugins/${1}"
  else
    echo "${_ZPM_PLUGIN_DIR}/${1//\//---}"
  fi
}

function _ZPM-plugin-name() {
  local plugin_name="${1}"
  plugin_name=${plugin_name##*\/}
  local plugin_owner=${plugin_name##*\/}
  # if [[ "${plugin_name}" == 'oh-my-zsh-'* ]]; then
  #   plugin_name=${plugin_name:10}
  # fi
  if [[ "${plugin_name}" == 'zsh-'* ]]; then
    plugin_name=${plugin_name:4}
  fi
  if [[ "${plugin_name}" == *'.zsh' ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-4}
  fi
  if [[ "${plugin_name}" == *'.plugin' ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-7}
  fi
  echo ${plugin_name}
}
function _ZPM-plugin-owner() {
  if [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    echo -en "${1%\/*}"
  else
    echo -en "zpm-zsh"
  fi
}

_ZPM-appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

_ZPM-if-fpath-not-empty(){

  for i in $1/_*(N); do
    return 0
  done
  
  return 1

}

_ZPM-recursive-exist(){
  local r_dir="$PWD"

  if [[ -d "$r_dir/$1" || -f "$r_dir/$1" ]]; then
    return 0
    echo "$r_dir/$1"
  fi
  while [[ "$r_dir" != "" ]]; do
    r_dir=$(dirname "$r_dir")
    if [[ "$r_dir" == '/' ]]; then
      r_dir=""
    fi
    if [[ -d "$r_dir/$1" || -f "$r_dir/$1" ]]; then
      return 0
    fi
  done

  return -1

}
