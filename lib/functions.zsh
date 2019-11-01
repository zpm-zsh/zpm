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

function _ZPM-get-plugin-base() {
  if [[  "$1" != *","* ]]; then
    echo "$1"
  else
    echo "$1" | awk -F',' '{print $1}'
  fi
}

function _ZPM-get-plugin-path() {
  local plugin_name=$(_ZPM-get-plugin-base $1)
  if [[  "$plugin_name" == 'zpm' ]]; then
    echo "${_ZPM_DIR}"
  else
    echo "${_ZPM_PLUGIN_DIR}/${plugin_name//\//---}"
  fi
}

function _ZPM-get-plugin-basename() {
  local plugin_name=$(_ZPM-get-plugin-base $1)
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

function _ZPM-get-plugin-url() {
  local plugin_name=$(_ZPM-get-plugin-base $1)
  
  if [[  "$plugin_name" == 'zpm' ]]; then
    echo "https://github.com/zpm-zsh/zpm"
  else
    echo "https://github.com/${plugin_name}"
  fi
  
}

function zpm(){
  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM-upgrade "$@"
    return 0
  fi
  
  if [[ "$1" == 'load' ]]; then
    shift
  fi
  
  if [[ "$1" == 'load-if' || "$1" == 'if' ]]; then
    if check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi
  
  if [[ "$1" == 'load-if-not' || "$1" == 'if-not' ]]; then
    if ! check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi
  
  _ZPM-initialize-plugin "$@"
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

post_fn(){
  echo 'PERIOD=5' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  echo 'zpm () {}' >> "$_ZPM_CACHE"

  echo >> "$_ZPM_CACHE"

  for file in $ZPM_files_for_source; do
    echo "source '$file'" >> "$_ZPM_CACHE"
  done

  echo >> "$_ZPM_CACHE"

  echo 'export PATH="'"${ZPM_PATH}"'${PATH}"' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  echo 'fpath=( '$ZPM_fpath' $fpath )' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  echo '_ZPM_Plugins=( '$_ZPM_Plugins' )' >> "$_ZPM_CACHE"

  echo >> "$_ZPM_CACHE"

  echo '_ZPM_post_fn () {' >> "$_ZPM_CACHE"

  for file in $ZPM_files_for_async_source; do
    echo "  source '$file'" >> "$_ZPM_CACHE"
  done

  echo >> "$_ZPM_CACHE"

  echo '  periodic_functions=(${periodic_functions:#_ZPM_post_fn})' >> "$_ZPM_CACHE"
  echo '}' >> "$_ZPM_CACHE"

  echo >> "$_ZPM_CACHE"

  echo 'periodic_functions+=(_ZPM_post_fn)' >> "$_ZPM_CACHE"
  zcompile "$_ZPM_CACHE"
  zcompile ~/.zshrc
}
