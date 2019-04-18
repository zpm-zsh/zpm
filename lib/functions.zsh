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
    echo Unknown plugin
  fi
}

function _ZPM-get-plugin-path() {
  if [[ $(_ZPM-plugin-type $1) == 'zpm' ]]; then
    echo ${_ZPM_DIR}
  elif [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    echo "${_ZPM_PLUGIN_DIR}/${1//\//---}"
  else
    echo Unknown plugin
  fi
}

function _ZPM-get-plugin-basename() {
  local plugin_name="${1}"
  plugin_name=${plugin_name##*\/}
  local plugin_owner=${plugin_name##*\/}
  if [[ "${plugin_name}" == 'oh-my-zsh-'* ]]; then
    plugin_name=${plugin_name:10}
  fi
  if [[ "${plugin_name}" == 'zsh-'* ]]; then
    plugin_name=${plugin_name:4}
  fi
  if [[ "${plugin_name}" == *'.zsh' ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-4}
  fi
  if [[ "${plugin_name}" == *'-zsh' ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-4}
  fi
  if [[ "${plugin_name}" == *'.plugin' ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-7}
  fi
  echo ${plugin_name}
}

function _ZPM-get-plugin-url() {

  if [[ $(_ZPM-plugin-type $1) == 'zpm' ]]; then
    echo "https://github.com/zpm-zsh/zpm"
  elif [[ $(_ZPM-plugin-type $1) == 'github' ]]; then
    echo "https://github.com/$1"
  else
    echo Unknown plugin
  fi

}
