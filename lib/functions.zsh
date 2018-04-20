#!/usr/bin/env zsh

function _ZPM-log() {
  if [[ "$DEBUG" == 'true' ]]; then
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
