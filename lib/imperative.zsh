#!/usr/bin/env zsh

typeset -a _zpm_required_dirs=(
  "${ZSH_TMP_DIR}"
  "${ZSH_TMP_DIR}/functions"
  "${ZSH_TMP_DIR}/bin"
  "${ZSH_DATA_HOME}"
  "${ZSH_DATA_HOME}/plugins"
  "${ZSH_DATA_HOME}/functions"
  "${ZSH_DATA_HOME}/scripts"
  "${ZSH_DATA_HOME}/site-functions"
  "${ZSH_CACHE_HOME}"
)

mkdir -p "${_zpm_required_dirs[@]}"
chmod go-w "${ZSH_TMP_DIR}"
unset _zpm_required_dirs

compinit -i -C -d "${_ZPM_COMPDUMP}"

typeset -g _zpm_parallel_format=''
typeset -g _zpm_parallel_launcher=''
typeset -g _zpm_parallel_item=''

function _zpm_use_parallel_runner() {
  _zpm_parallel_format='%s\n'
  _zpm_parallel_launcher='parallel'
  _zpm_parallel_item='{1}'
}

function _zpm_use_rush_runner() {
  _zpm_parallel_format='%s\n'
  _zpm_parallel_launcher='rush'
  _zpm_parallel_item='"{}"'
}

function _zpm_use_xargs_runner() {
  _zpm_parallel_format='%s\0'
  _zpm_parallel_launcher='xargs -0 -P12 -I{}'
  _zpm_parallel_item='{}'
}

function _zpm_select_parallel_runner() {
  local requested="${_ZPM_PARALLEL_RUNNER:-}"

  case "$requested" in
    parallel) _zpm_use_parallel_runner; return 0 ;;
    rush)     _zpm_use_rush_runner; return 0 ;;
    xargs)    _zpm_use_xargs_runner; return 0 ;;
    '')       ;;
    *)        echo "Can't detect parallel runner" >&2; return 1 ;;
  esac

  if (( $+commands[parallel] )); then
    _zpm_use_parallel_runner
  elif (( $+commands[rush] )); then
    _zpm_use_rush_runner
  else
    _zpm_use_xargs_runner
  fi
}

_zpm_select_parallel_runner || return 0

typeset -gA _ZPM_plugins_full=(
  [@zpm]='@zpm'
)

@zpm-load-plugins zpm-zsh/helpers

sched +1 @zpm-background-initialization

function source() {
  local target="$1"
  [[ -n "$target" ]] || return 1

  if [[ ! "${target}.zwc" -nt "${target}" ]]; then
    zcompile "$target" 2>/dev/null
  fi

  builtin source "$target"
}
