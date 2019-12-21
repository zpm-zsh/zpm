#!/usr/bin/env zsh
function zpm(){
  if [[ "$1" == 'c' || "$1" == 'cl' || "$1" == 'clean' ]]; then
    shift
    _ZPM_clean
    return 0
  fi
  
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

function _ZPM-load-plugin() {
  local Plugin_path=$(_ZPM-get-plugin-path "$1")
  local Plugin_basename=$(_ZPM-get-plugin-basename "$1")
  local Plugin_name=$(_ZPM-get-plugin-name "$1")
  
  if [[ ! -e "${Plugin_path}" ]]; then
    _ZPM-log zpm:init:skip "Skip initialization of '${1}', plugin directory not found '${Plugin_path}'"
    return -1
  fi
  
  _ZPM-log zpm:init "Initialize '${Plugin_name}'"
  
  local _ZPM_local_source=true
  local _ZPM_local_async=false
  local _ZPM_local_path=true
  local _ZPM_local_fpath=true
  
  if [[ "$1"  == *",apply:"* ]]; then
    local _ZPM_tag_str=${1##*,apply:}
    _ZPM_tag_str=${_ZPM_tag_str%%\,*}
    
    if [[ "$_ZPM_tag_str" != *'source'* ]]; then
      _ZPM_local_source=false
    fi
    
    if [[ "$_ZPM_tag_str" != *'path'* ]]; then
      _ZPM_local_path=false
    fi
    
    if [[ "$_ZPM_tag_str" != *'fpath'* ]]; then
      _ZPM_local_fpath=false
    fi
  fi
  
  if [[ "$1"  == *",async"* ]]; then
    _ZPM_local_async=true
  fi
    
  if [[ "$_ZPM_local_fpath"  == "true" ]]; then
    if [[ "$1"  == *",fpath:"* ]]; then
      local zpm_fpath=${${1##*,fpath:}%%,*}
      local _local_path="${Plugin_path}/${zpm_fpath}"
      _ZPM-log zpm:init:fpath "Add to \$fpath '${_local_path}'"
      _ZPM-addfpath "${_local_path:a}"
    else
      for file in  "${Plugin_path}/_"*(N); do
        _ZPM-log zpm:init:fpath "Add to \$fpath '${Plugin_path:a}'"
        _ZPM-addfpath "${Plugin_path:a}"
        break;
      done
    fi
  fi
  
  if [[ "$_ZPM_local_path"  == "true" ]]; then
    if [[ "$1"  == *",path:"* ]]; then
      local zpm_path=${${1##*,path:}%%,*}
      local _local_path="${Plugin_path}/${zpm_path}"
      _ZPM-log zpm:init:path "Add to \$PATH '${_local_path}'"
      _ZPM-addpath "${_local_path:a}"
    elif [[ -d ${Plugin_path}/bin ]]; then
      _ZPM-log zpm:init:path "Add to \$PATH '${_local_path:a}/bin'"
      _ZPM-addpath "${Plugin_path:a}"
    fi
  fi
  
  if [[ "$_ZPM_local_source"  == "true" ]]; then
    if [[ "$1"  == *",source:"* ]]; then
      _ZPM_plugin_file_path=$(
        _ZPM-get-plugin-file-path "${Plugin_path}" "${Plugin_basename}" "${${1##*,source:}%%,*}"
      )
    else
      _ZPM_plugin_file_path=$(
        _ZPM-get-plugin-file-path "${Plugin_path}" "${Plugin_basename}"
      )
    fi
    
    if [[ -n "$_ZPM_plugin_file_path" ]]; then
      if [[ "$_ZPM_local_async" == "true" ]]; then
        _ZPM-log zpm:init:source "Source '${_ZPM_plugin_file_path}', async, inline"
        _ZPM_async_source "${Plugin_name}" "${_ZPM_plugin_file_path}"
      else
        _ZPM-log zpm:init:source "Source '${_ZPM_plugin_file_path}', sync, inline"
        _ZPM_source "${Plugin_name}" "${_ZPM_plugin_file_path}"
      fi
    else
      _ZPM_no_source "${Plugin_name}"
    fi
  else
    _ZPM_no_source "${Plugin_name}"
  fi
  
}

function _ZPM-initialize-plugin() {
  # Check if plugin isn't loaded
  declare -a _Plugins_Install
  
  for plugin ("$@"); do
    local Plugin_path=$(_ZPM-get-plugin-path "$plugin")
    
    if [[ ! -e $Plugin_path ]]; then
      _Plugins_Install+=("$plugin")
    fi
  done
  
  if [[ -n "$_Plugins_Install[@]" ]]; then;
    printf '%s\0' "${_Plugins_Install[@]}" | \
    xargs -0 -P16 -n1 "${_ZPM_DIR}/bin/_ZPM-plugin-helper" install
  fi
  
  for plugin ($@); do
    local plugin_name=$(_ZPM-get-plugin-name "$plugin")
    if [[ " ${zsh_loaded_plugins[*]} " != *"$plugin_name"* ]]; then
      _ZPM_plugins_full[$plugin_name]="$plugin"
      _ZPM-load-plugin "$plugin"
    else
      _ZPM-log zpm:init:skip "Skip initialization '$1', plugin already loaded"
    fi
  done
}

function _ZPM_clean(){
  rm                          \
    -f "${_ZPM_CACHE}"        \
    "${_ZPM_CACHE_ASYNC}"     \
    "${_ZPM_CACHE}.zwc"       \
    "${_ZPM_CACHE_ASYNC}.zwc" \
    "${HOME}/.zcompdump"      \
    "${HOME}/.zcompdump.zwc"  \
    2>/dev/null
}

function _ZPM-upgrade(){
  typeset -a _Plugins_Upgrade=()
  typeset -a _Plugins_Upgrade_full=()
  
  _ZPM_clean
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=("zpm" $zsh_loaded_plugins)
  else
    _Plugins_Upgrade+=($@)
  fi
  
  for plugin (${_Plugins_Upgrade}); do
    _Plugins_Upgrade_full+=($_ZPM_plugins_full[$plugin])
  done
  
  printf '%s\0' "${_Plugins_Upgrade_full[@]}" | \
  xargs -0 -P32 -n1 "${_ZPM_DIR}/bin/_ZPM-plugin-helper" upgrade
}

function _ZPM-get-plugin-file-path() {
  if [[ -n "${3}" ]]; then
    echo "${1}/${3}"
    return 0
  fi
  
  if [[ -e "${1}/${2}.plugin.zsh" ]]; then
    echo "${1}/${2}.plugin.zsh"
    return 0
  fi
  if [[ -e "${1}/zsh-${2}.plugin.zsh" ]]; then
    echo "${1}/zsh-${2}.plugin.zsh"
    return 0
  fi
  
  if [[ -e "${1}/${2}.zsh" ]]; then
    echo "${1}/${2}.zsh"
    return 0
  fi
  
  if [[ -e "${1}/${2}.zsh-theme" ]]; then
    echo "${1}/${2}.zsh-theme"
    return 0
  fi
  
  if [[ -e "${1}/init.zsh" ]]; then
    echo "${1}/init.zsh"
    return 0
  fi
  
  return -1
}

function _ZPM-get-plugin-type() {
  if [[ "$1" == 'zpm' ]]; then
    echo 'zpm'
    return 0
  fi
  
  local _ZPM_tag_str=${1##*,type:}
  _ZPM_tag_str=${_ZPM_tag_str%%\,*}
  
  if [[ "$_ZPM_tag_str" == *'gitlab'* ]]; then
    echo 'gitlab'
    return 0
  fi
  
  if [[ "$_ZPM_tag_str" == *'bitbucket'* ]]; then
    echo 'bitbucket'
    return 0
  fi
  
  if [[ "$1" == 'omz/'* ]]; then
    echo 'omz'
    return 0
  fi
  
  if [[ "$_ZPM_tag_str" == *'omz'* ]]; then
    echo 'omz'
    return 0
  fi
  
  echo "github"
}

function _ZPM-get-plugin-name() {
  echo "${1%%,*}"
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
  local plugin_name=$(_ZPM-get-plugin-name "$1")
  local plugin_type=$(_ZPM-get-plugin-type "$1")
  
  if [[ "$plugin_type" == 'github' ]]; then
    echo "https://github.com/${plugin_name}"
    return 0
  fi
  
  if [[ "$plugin_type" == 'gitlab' ]]; then
    echo "https://gitlab.com/${plugin_name}"
    return 0
  fi
  
  if [[ "$plugin_type" == 'bitbucket' ]]; then
    echo "https://bitbucket.com/${plugin_name}"
    return 0
  fi
  
  if [[ "$plugin_type" == 'zpm' ]]; then
    echo "https://github.com/zpm-zsh/zpm"
    return 0
  fi
  
  if [[ "$plugin_type" == 'omz' ]]; then
    echo "https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/${plugin_name}"
    return 0
  fi
  
  echo
}

_ZPM-addpath () {
  _ZPM_PATH="${_ZPM_PATH}:${1:A}"
  if [[ ":$PATH:" != *:"$1":* ]]; then
    PATH="$PATH:${1}"
  fi
}

_ZPM-addfpath () {
  _ZPM_fpath=( $_ZPM_fpath "${1:A}" )
  if [[ ":$FPATH:" != *:"$1":* ]]; then
    fpath=( $fpath "${1}" )
  fi
}

# Fake source
source () {
  if [[ -f "$1" && ( ! -s "$1.zwc" || "$1" -nt "$1.zwc") ]]; then;
    zcompile "$1" 2>/dev/null
  fi
  
  builtin source "$1"
}

_ZPM_source () {
  zsh_loaded_plugins+=("$1")
  ZERO="$2"
  
  source "$2"
  
  _ZPM_plugins_for_source+=("$1")
  _ZPM_file_for_source["$1"]="${2}___ZPM_inline"
  
  unset ZERO
}

_ZPM_async_source () {
  zsh_loaded_plugins+=("$1")
  ZERO="$2"
  
  source "$2"
  
  _ZPM_plugins_for_async_source+=("$1")
  _ZPM_file_for_async_source["$1"]="${2}___ZPM_inline"
  
  unset ZERO
}

_ZPM_no_source (){
  zsh_loaded_plugins+=("$1")
  _ZPM_plugins_no_source+=("$1")
}
