#!/usr/bin/env zsh

function zpm() {
  if [[ "$1" == 'c' || "$1" == 'cl' || "$1" == 'clean' ]]; then
    shift
    _ZPM_clean
    return 0
  fi

  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM_upgrade "$@"
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

  _ZPM_initialize_plugin "$@"
}

# Fake source
function source() {
  if [[ -f "$1" && ( ! -s "$1.zwc" || "$1" -nt "$1.zwc") ]]; then;
    zcompile "$1" 2>/dev/null
  fi

  builtin source "$1"
}

function _ZPM_source() {
  zsh_loaded_plugins+=("$1")
  ZERO="$2"

  source "$2"

  _ZPM_plugins_for_source+=("$1")
  _ZPM_file_for_source["$1"]="${2}"

  unset ZERO
}

function _ZPM_async_source() {
  zsh_loaded_plugins+=("$1")
  ZERO="$2"

  source "$2"

  _ZPM_plugins_for_async_source+=("$1")
  _ZPM_file_for_async_source["$1"]="${2}"

  unset ZERO
}

function _ZPM_no_source() {
  zsh_loaded_plugins+=("$1")
  _ZPM_plugins_no_source+=("$1")
}
