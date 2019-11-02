#!/usr/bin/env zsh

touch "$_ZPM_CACHE"
_ZPM_Plugins=()

function _ZPM-upgrade(){
  declare -a _Plugins_Upgrade
  
  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "zpm" $_ZPM_Plugins )
  else
    _Plugins_Upgrade+=($@)
  fi
  
  printf '%s\0' "${_Plugins_Upgrade[@]}" | \
  xargs -0 -P16 -n1 "${${(%):-%x}:a:h}/../bin/_ZPM-plugin-helper" upgrade
  
  for plugin ($@); do
    local plugin_basename=$(_ZPM-get-plugin-basename $plugin)
  done
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

post_fn(){
  echo 'zpm () {}' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'export PATH="'"${ZPM_PATH}"'${PATH}"' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'fpath=( $fpath '$ZPM_fpath' )' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  for file in $ZPM_files_for_source; do
    echo "source '$file'" >> "$_ZPM_CACHE"
  done
  echo >> "$_ZPM_CACHE"
  
  echo '_ZPM_post_fn () {' >> "$_ZPM_CACHE"
  
  for file in $ZPM_files_for_async_source; do
    echo "  source '$file'" >> "$_ZPM_CACHE"
  done
  echo >> "$_ZPM_CACHE"
  
  echo "  source '${_ZPM_DIR}/lib/functions.zsh'" >> "$_ZPM_CACHE"
  echo "  source '${_ZPM_DIR}/lib/core.zsh'" >> "$_ZPM_CACHE"
  echo "  source '${_ZPM_DIR}/lib/initialize.zsh'" >> "$_ZPM_CACHE"
  echo "  source '${_ZPM_DIR}/lib/declarative.zsh'" >> "$_ZPM_CACHE"
  echo "  source '${_ZPM_DIR}/lib/completion.zsh'" >> "$_ZPM_CACHE"
  
  echo >> "$_ZPM_CACHE"
  
  echo '  TMOUT=5' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo '  add-zsh-hook -d background _ZPM_post_fn' >> "$_ZPM_CACHE"
  echo '}' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'typeset -aU path' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo "_ZPM_Plugins=(${_ZPM_Plugins})" >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'export PATH' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'TMOUT=1' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'add-zsh-hook background _ZPM_post_fn' >> "$_ZPM_CACHE"
  zcompile "$_ZPM_CACHE"
  zcompile ~/.zshrc
}

function _ZPM_Post_Initialization(){
  post_fn
  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ZPM_Post_Initialization
