#!/usr/bin/env zsh

_LS=(=ls)

if (( $+commands[gls] )); then
  _LS=(\=gls)
fi

_LS_IS_GNU="false" # FIXME: Doesn't work on BSD* systems
if $_LS --version >/dev/null 2>&1 ; then
  _LS_IS_GNU="true"
fi

_LS_GRC=""
if (( $+commands[grc] )); then
  _LS_GRC=("grc" "--config=${${(%):-%x}:a:h}/conf.ls")
fi

_LS_COLOR=""


if [[ "$_LS_IS_GNU" == "true" ]]; then

  if [[ "$COLORS" == "true" ]]; then
    _LS_COLOR="--color"
  else
    _LS_COLOR="--color=never"
    _LS_GRC=""
  fi

  function ll(){
    $_LS_GRC $_LS $_LS_COLOR -lFh --group-directories-first --time-style=+%Y-%m-%d\ %H:%M $@
  }
  compdef ll=ls

  function lsd(){
    $_LS_GRC $_LS $_LS_COLOR -lFh --group-directories-first --time-style=+%Y-%m-%d\ %H:%M -d $@ *(-/DN)
  }
  compdef lsd=ls

  function la(){
    $_LS $_LS_COLOR -CFlxBh --group-directories-first -A $@
  }
  compdef la=ls

  function l(){
    $_LS $_LS_COLOR -CFlxBh --group-directories-first $@
  }
  compdef l=ls

  function ls(){
    $_LS $_LS_COLOR -CFlxBh --group-directories-first $@
  }
  compdef ls=ls

else

  if [[ "$COLORS" == "true" ]]; then
    _LS_COLOR="-G"
  else
    _LS_COLOR=""
    _LS_GRC=""
  fi

  function ll(){
    $_LS_GRC $_LS $_LS_COLOR -lFh $@
  }
  compdef ll=ls

  function lsd(){
    $_LS_GRC $_LS $_LS_COLOR -lFh -d $@ *(-/DN)
  }
  compdef lsd=ls

  function la(){
    $_LS $_LS_COLOR -CFlxBh -A $@
  }
  compdef la=ls

  function l(){
    $_LS $_LS_COLOR -CFlxBh $@
  }
  compdef l=ls

  function ls(){
    $_LS $_LS_COLOR -CFlxBh $@
  }
  compdef ls=ls

fi
