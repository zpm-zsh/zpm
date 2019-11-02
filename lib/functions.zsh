#!/usr/bin/env zsh

function _ZPM-log() {
  
  if [[ -n "$DEBUG" &&  "${1}:" == "${DEBUG}:"*  ]]; then
    
    num=0
    
    for i in $(seq 1 ${#1}); do
      num=$(( $num + $(LC_CTYPE=C printf '%d' "'${1[$i]})") ))
    done
    color=$(( $num % 6 + 1 ))
    
    echo -n "[1;3${color}m$1 [0m"
    shift
    echo "$@"
  fi
}

function _ZPM-get-plugin-type() {
  local type='github'
  
  local _ZPM_tag_str=$(echo "$1" | awk -F'type:' '{print $2}' | awk -F',' '{print $1}')
  
  if [[ "$_ZPM_tag_str" == *'gitlab'* ]]; then
    type='gitlab'
  elif [[ "$_ZPM_tag_str" == *'bitbucket'* ]]; then
    type='bitbucket'
  elif [[ "$_ZPM_tag_str" == *'omz'* ]]; then
    type='omz'
  fi
  
  echo "$type"
}

function _ZPM-get-plugin-name() {
  echo "$1" | awk -F',' '{print $1}'
}

function _ZPM-get-plugin-path() {
  local plugin_name=$(_ZPM-get-plugin-name $1)
  echo "${_ZPM_PLUGIN_DIR}/${plugin_name//\//---}"
}

function _ZPM-get-plugin-basename() {
  local plugin_name=$(_ZPM-get-plugin-name $1)
  plugin_name=${plugin_name##*\/}
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
  echo "${plugin_name}"
}

function _ZPM-get-plugin-link() {
  local plugin_name=$(_ZPM-get-plugin-name $1)
  local plugin_type=$(_ZPM-get-plugin-type $1)
  
  if [[  "$plugin_name" == 'zpm' ]]; then
    echo "https://github.com/zpm-zsh/zpm"
  else
    if [[ "$plugin_type" == 'github' ]]; then
      echo "https://github.com/${plugin_name}"
    elif [[ "$plugin_type" == 'gitlab' ]]; then
      echo "https://gitlab.com/${plugin_name}"
    elif [[ "$plugin_type" == 'bitbucket' ]]; then
      echo "https://bitbucket.com/${plugin_name}"
    elif [[ "$plugin_type" == 'omz' ]]; then
      echo "https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/${plugin_name}"
    else
      echo
    fi
  fi
}

_ZPM-addpath () {
  case ":$PATH:" in
    *:"$1":*)
    ;;
    *)
      PATH="${1:A}:$PATH"
      ZPM_PATH="${1:A}:$ZPM_PATH"
  esac
}

_ZPM-addfpath () {
  case ":$FPATH:" in
    *:"$1":*)
    ;;
    *)
      fpath=("${1:A}" $fpath )
      ZPM_fpath=("${1:A}" $ZPM_fpath )
  esac
}

# Fake source
source () {
  if [[ -f "$1" && ( ! -s "$1.zwc" || "$1" -nt "$1.zwc") ]]; then; zcompile "$1" 2>/dev/null; fi;
  builtin source "$1"
}

_ZPM_source () {
  source "$1"
  ZPM_files_for_source+=("${1:A}")
}

_ZPM_async_source () {
  source "$1"
  ZPM_files_for_async_source+=("${1:A}" )
}
