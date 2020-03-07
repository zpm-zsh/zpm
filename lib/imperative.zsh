#!/usr/bin/env zsh

typeset _ZPM_PATH=""
typeset _ZPM_fpath=()

typeset -A _ZPM_plugins_full
_ZPM_plugins_full[zpm]="zpm"

typeset -a _ZPM_plugins_for_source
typeset -a _ZPM_plugins_for_async_source
typeset -a _ZPM_plugins_no_source

typeset -A _ZPM_file_for_source
typeset -A _ZPM_file_for_async_source


function _ZPM_Background_Initialization() {
  mkdir -p "${_ZPM_CACHE:h}"

  _ZPM_TMP="$(mktemp)"
  _ZPM_TMP_ASYNC="$(mktemp)"

  echo "$(typeset -p _ZPM_plugins_full)" >> "$_ZPM_TMP"

  echo "export PATH=\"\${PATH}${_ZPM_PATH}\"" >> "$_ZPM_TMP"
  echo "fpath+=( '${(j:' ':)_ZPM_fpath}' )" >> "$_ZPM_TMP"
  echo >> "$_ZPM_TMP"

  echo 'autoload -Uz compinit' >> "$_ZPM_TMP"
  echo 'local _comp_files' >> "$_ZPM_TMP"
  echo '_comp_files=(${HOME}/.zcompdump(Nm-20))' >> "$_ZPM_TMP"
  echo 'if (( $#_comp_files )); then' >> "$_ZPM_TMP"
  echo '  compinit -i -C' >> "$_ZPM_TMP"
  echo 'else' >> "$_ZPM_TMP"
  echo '  compinit -i' >> "$_ZPM_TMP"
  echo 'fi' >> "$_ZPM_TMP"
  echo 'unset _comp_files' >> "$_ZPM_TMP"
  echo >> "$_ZPM_TMP"

  for plugin in ${_ZPM_plugins_for_source}; do
    local file="$_ZPM_file_for_source["$plugin"]"
    echo "zsh_loaded_plugins+=('$plugin')" >> "$_ZPM_TMP"
    echo "ZERO='${file}'" >> "$_ZPM_TMP"
    cat "${file}" >> "$_ZPM_TMP"
    echo >> "$_ZPM_TMP"
  done

  echo '_ZPM_post_fn () {' >> "$_ZPM_TMP"
  echo "  source '$_ZPM_CACHE_ASYNC'" >> "$_ZPM_TMP"
  echo '  TMOUT=5' >> "$_ZPM_TMP"
  echo '  add-zsh-hook -d background _ZPM_post_fn' >> "$_ZPM_TMP"
  echo '}' >> "$_ZPM_TMP"
  echo >> "$_ZPM_TMP"

  echo 'typeset -aU path' >> "$_ZPM_TMP"
  echo 'export PATH' >> "$_ZPM_TMP"
  echo >> "$_ZPM_TMP"

  echo 'TMOUT=1' >> "$_ZPM_TMP"
  echo >> "$_ZPM_TMP"

  if [[ -z "$ZPM_NO_ASYNC_HOOK" ]]; then
    echo 'add-zsh-hook background _ZPM_post_fn' >> "$_ZPM_TMP"
    echo >> "$_ZPM_TMP"
    echo 'zpm () {}' >> "$_ZPM_TMP"
  else
    echo '_ZPM_post_fn' >> "$_ZPM_TMP"
  fi

  for plugin in ${_ZPM_plugins_for_async_source}; do
    local file="$_ZPM_file_for_async_source["$plugin"]"
    echo "zsh_loaded_plugins+=('$plugin')" >> "$_ZPM_TMP_ASYNC"
    echo "ZERO='${file}'" >> "$_ZPM_TMP_ASYNC"
    cat "${file}" >> "$_ZPM_TMP_ASYNC"
    echo >> "$_ZPM_TMP_ASYNC"
  done

  echo 'unset ZERO' >> "$_ZPM_TMP_ASYNC"

  cat "${_ZPM_DIR}/lib/functions.zsh" >> "$_ZPM_TMP_ASYNC"
  cat "${_ZPM_DIR}/lib/completion.zsh" >> "$_ZPM_TMP_ASYNC"

  mv "$_ZPM_TMP" "$_ZPM_CACHE"
  mv "$_ZPM_TMP_ASYNC" "$_ZPM_CACHE_ASYNC"

  zcompile "$_ZPM_CACHE" 2>/dev/null
  zcompile "$_ZPM_CACHE_ASYNC" 2>/dev/null
  zcompile "${HOME}/.zshrc" 2>/dev/null
  zcompile "${HOME}/.zshrc.local" 2>/dev/null
  zcompile "${_ZPM_DIR}/zpm.zsh" 2>/dev/null
  zcompile "${_ZPM_DIR}/lib/functions.zsh" 2>/dev/null

  add-zsh-hook -d background _ZPM_Background_Initialization
}

function _ZPM_Post_Initialization() {
  if [[ -z "$ZPM_NO_ASYNC_HOOK" ]]; then
    add-zsh-hook background _ZPM_Background_Initialization
  else
    _ZPM_Background_Initialization
  fi

  compinit

  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ZPM_Post_Initialization

autoload -Uz compinit
local _comp_files=(${HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files

zpm zpm-zsh/helpers zpm-zsh/colors zpm-zsh/background
