#!/usr/bin/env zsh

_LS_LS="$(whence ls)"

if (( $+commands[gls] )); then
  echo oo
  _LS_LS="$(whence gls)"
fi

_LS_IS_GNU_LS="false" # FIXME: Doesn't work on BSD* systems
if ls --version >/dev/null 2>&1 ; then
  _LS_IS_GNU_LS="true"
fi

_LS_GRC=""
if (( $+commands[grc] )); then
  _LS_GRC="grc --config=${${(%):-%x}:a:h}/conf.other "
fi

_LS_COLOR=""


if [[ "$_LS_IS_GNU_LS" == "true" ]]; then
  
  if [[ "$COLORS" == "true" ]]; then
    _LS_COLOR="--color"
  else
    _LS_COLOR="--color=never"
    _LS_GRC=""
  fi

  function ll(){
    eval "$_LS_GRC $_LS_LS $_LS_COLOR -lFh --group-directories-first --time-style=+%Y-%m-%d\ %H:%M"
  }
  compdef ll=ls

  function lsd(){
    eval "$_LS_GRC $_LS_LS $_LS_COLOR -lFh --group-directories-first --time-style=+%Y-%m-%d\ %H:%M -d *(-/DN)"
  }
  compdef lsd=ls

  function la(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh --group-directories-first -A"
  }
  compdef la=ls

  function l(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh --group-directories-first"
  }
  compdef l=ls

  function ls(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh --group-directories-first"
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
    eval "$_LS_GRC $_LS_LS $_LS_COLOR -lFh"
  }
  compdef ll=ls

  function lsd(){
    eval "$_LS_GRC $_LS_LS $_LS_COLOR -lFh -d *(-/DN)"
  }
  compdef lsd=ls

  function la(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh -A"
  }
  compdef la=ls

  function l(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh"
  }
  compdef l=ls

  function ls(){
    eval "$_LS_LS $_LS_COLOR -CFlxBh"
  }
  compdef ls=ls

fi
