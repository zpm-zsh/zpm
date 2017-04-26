#!/usr/bin/env zsh

local LS="$(whence ls)"

if (( $+commands[gls] )); then
  LS="$(whence gls)"
fi

local IS_GNU_LS="false" # FIXME: Doesn't work on BSD* systems
if ls --version >/dev/null 2>&1 ; then
  IS_GNU_LS="true"
fi

local GRC=""
if (( $+commands[grc] )); then
  GRC="grc --config=${${(%):-%x}:a:h}/conf.other "
fi

local COLOR=""
if [[ "$COLORS" == "true" ]]; then
  COLOR="--color"
else
  COLOR="--color=never"
  GRC=""
fi

if [[ "$IS_GNU_LS" == "true" ]]; then
    alias ll="$GRC$LS $COLOR -lFh  --group-directories-first --time-style=+%Y-%m-%d\ %H:%M"
    alias lsd="$GRC$LS $COLOR -lFh  --group-directories-first --time-style=+%Y-%m-%d\ %H:%M -d *(-/DN)"

    alias ls='$LS $COLOR -CFlxBh --group-directories-first'
    alias l="$LS $COLOR -CFlxBh --group-directories-first"
    alias la='$LS $COLOR -CFlxBh --group-directories-first -A'
fi
