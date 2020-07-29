#!/usr/bin/env zsh

typeset -g _ZPM_path=()
typeset -g _ZPM_fpath=()
typeset -g _ZPM_autoload=()

typeset -ag _ZPM_plugins_for_source
typeset -ag _ZPM_plugins_for_async_source
typeset -ag _ZPM_plugins_no_source

typeset -Ag _ZPM_file_for_source
typeset -Ag _ZPM_file_for_async_source

fpath+=("${_ZPM_DIR}/functions")

autoload -Uz                     \
  @zpm-add-autoload      \
  @zpm-addfpath      \
  @zpm-addpath      \
  @zpm-async-source      \
  @zpm-background-initialization      \
  @zpm-clean      \
  @zpm-compile      \
  @zpm-get-git-work-tree      \
  @zpm-get-plugin-autoload      \
  @zpm-get-plugin-basename      \
  @zpm-get-plugin-bin-path      \
  @zpm-get-plugin-file-path      \
  @zpm-get-plugin-functions-path      \
  @zpm-get-plugin-hyperlink      \
  @zpm-get-plugin-link      \
  @zpm-get-plugin-name      \
  @zpm-get-plugin-path      \
  @zpm-get-plugin-type      \
  @zpm-initialize-plugin      \
  @zpm-load-plugins      \
  @zpm-log      \
  @zpm-no-source      \
  @zpm-source      \
  @zpm-upgrade      \


  function zpm() {
  if [[ "$1" == 'load' ]]; then
    shift
    @zpm-load-plugins "$@"
    return 0
  fi

  if [[ "$1" == 'if' ]]; then
    if check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi

  if [[ "$1" == 'if-not' ]]; then
    if ! check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi

  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    @zpm-upgrade "$@"
    return 0
  fi

  if [[ "$1" == 'c' || "$1" == 'cl' || "$1" == 'clean' ]]; then
    @zpm-clean
  fi

  if is-callable "zpm-$1"; then
    local call_fn=$1
    shift
    "zpm-${call_fn}" $@
    return 0
  fi

  echo 'Unknown command `zpm '"$@"'`, treat as `zpm load '"$@"'`'
  @zpm-load-plugins "$@"
}
