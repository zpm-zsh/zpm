#!/usr/bin/env zsh
typeset -g _ZPM_autoload=()

typeset -ag _ZPM_plugins_for_source
typeset -ag _ZPM_plugins_for_async_source
typeset -ag _ZPM_plugins_no_source

typeset -Ag _ZPM_file_for_source
typeset -Ag _ZPM_file_for_async_source

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

autoload -Uz \
  zpm                            \
  @zpm-add-autoload              \
  @zpm-addfpath                  \
  @zpm-addpath                   \
  @zpm-async-source              \
  @zpm-background-initialization \
  @zpm-clean                     \
  @zpm-compile                   \
  @zpm-get-plugin-autoload       \
  @zpm-get-plugin-basename       \
  @zpm-get-plugin-bin-path       \
  @zpm-get-plugin-file-path      \
  @zpm-get-plugin-functions-path \
  @zpm-get-plugin-name           \
  @zpm-get-plugin-origin-type    \
  @zpm-get-plugin-path           \
  @zpm-initialize-plugin         \
  @zpm-launch-plugin-helper      \
  @zpm-load-plugins              \
  @zpm-log                       \
  @zpm-no-source                 \
  @zpm-source                    \
  @zpm-upgrade
