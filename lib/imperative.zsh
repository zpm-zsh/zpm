#!/usr/bin/env zsh

mkdir -p "${ZSH_TMP_DIR}" "${ZSH_TMP_DIR}/functions" "${ZSH_TMP_DIR}/bin" "${ZSH_DATA_HOME}" "${ZSH_DATA_HOME}/plugins" "${ZSH_DATA_HOME}/plugins/" "${ZSH_DATA_HOME}/functions" "${ZSH_DATA_HOME}/scripts" "${ZSH_DATA_HOME}/site-functions" "${ZSH_CACHE_HOME}"

compinit -i -C -d "${_ZPM_COMPDUMP}"

typeset -g _zpm_parallel_format
typeset -g _zpm_parallel_launcher
typeset -g _zpm_parallel_item

function _zpm_use_parallel_runner() {
  _zpm_parallel_format='%s\n'
  _zpm_parallel_launcher="parallel"
  _zpm_parallel_item='{1}'
}

function _zpm_use_rush_runner() {
  _zpm_parallel_format='%s\n'
  _zpm_parallel_launcher="rush"
  _zpm_parallel_item='"{}"'
}

function _zpm_use_xargs_runner() {
  _zpm_parallel_format='%s\0'
  _zpm_parallel_launcher="xargs -0 -P12 -I{}"
  _zpm_parallel_item='{}'
}

if [[ -n "$_ZPM_PARALLEL_RUNNER" ]]; then
  if [[ "$_ZPM_PARALLEL_RUNNER" = 'parallel' ]]; then
    _zpm_use_parallel_runner
  elif [[ "$_ZPM_PARALLEL_RUNNER" = 'rush' ]]; then
    _zpm_use_rush_runner
  elif [[ "$_ZPM_PARALLEL_RUNNER" = 'xargs' ]]; then
    _zpm_use_xargs_runner
  else
    echo "Can't detect parallel runner"
    return 0
  fi
else
  if (( $+commands[parallel] )); then
    _zpm_use_parallel_runner
  elif (( $+commands[rush] )); then
    _zpm_use_rush_runner
  else
    _zpm_use_xargs_runner
  fi
fi

declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
@zpm-load-plugins zpm-zsh/helpers

sched +1 @zpm-background-initialization

function source() {
  if [[ ! "${1}.zwc" -nt "${1}" ]]; then
    zcompile "${1}" 2>/dev/null
  fi

  builtin source "$1"
}
