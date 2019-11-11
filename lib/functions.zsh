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

function _ZPM_clean(){
  rm -f "${_ZPM_CACHE}" "${_ZPM_CACHE}.zwc" "${HOME}/.zcompdump" "${HOME}/.zcompdump.zwc" 2>/dev/null
}

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade
  rm "$_ZPM_CACHE" 2>/dev/null
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $zsh_loaded_plugins )
  else
    _Plugins_Upgrade+=($@)
  fi
  
  printf '%s\0' "${_Plugins_Upgrade[@]}" | \
  xargs -0 -P32 -n1 "${_ZPM_DIR}/bin/_ZPM-plugin-helper" upgrade
  
  for plugin ($@); do
    local plugin_basename=$(_ZPM-get-plugin-basename $plugin)
  done
}

function _ZPM-get-plugin-file-path() {
  if [[ ! -z "${3}" ]]; then
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

function _ZPM-get-plugin-repo-type() {
  if [[ "$1" == 'zpm' ]]; then
    echo 'zpm'
    return 0
  fi
  
  if [[ "$1" == 'omz/'* ]]; then
    echo 'omz'
    return 0
  fi
    
  echo "git"
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
  local plugin_name=$(_ZPM-get-plugin-name $1)
  local plugin_type=$(_ZPM-get-plugin-type $1)
  
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
  _ZPM_PATH="${1:A}:$_ZPM_PATH"
  case ":$PATH:" in
    *:"$1":*)
    ;;
    *)
      PATH="${1:A}:$PATH"
  esac
}

_ZPM-addfpath () {
  _ZPM_fpath=("${1:A}" $_ZPM_fpath )
  case ":$FPATH:" in
    *:"$1":*)
    ;;
    *)
      fpath=("${1:A}" $fpath )
  esac
}

# Fake source
source () {
  if [[ -f "$1" && ( ! -s "$1.zwc" || "$1" -nt "$1.zwc") ]]; then;
    zcompile "$1" 2>/dev/null
  fi
  
  builtin source "$1"
}

_ZPM_source () {
  source "$2"
  _ZPM_plugins_for_source+=("$1")
  _ZPM_file_for_source["$1"]="${2:A}"
}

_ZPM_inline_source () {
  source "$2"
  _ZPM_plugins_for_source+=("$1")
  _ZPM_file_for_source["$1"]="${2:A}___ZPM_inline"
}

_ZPM_async_source () {
  source "$2"
  _ZPM_plugins_for_async_source+=("$1")
  _ZPM_file_for_async_source["$1"]="${2:A}"
}

_ZPM_inline_async_source () {
  source "$2"
  _ZPM_plugins_for_async_source+=("$1")
  _ZPM_file_for_async_source["$1"]="${2:A}___ZPM_inline"
}

_ZPM_no_source (){
  _ZPM_plugins_no_source+=("$1")
}
