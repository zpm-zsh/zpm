#!/usr/bin/env zsh

if ls --version >/dev/null 2>&1 ; then
    if [[ $COLORS == "true" ]]; then
        if hash grc 2>/dev/null; then
            alias ll="grc --config=${0:a:h}/conf.other ls -lFh --color  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M"
            alias lsd="grc --config=${0:a:h}/conf.other ls -lFh --color  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M -d *(-/DN)"
        else
            alias ll="ls -lFh --color  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M"
            alias lsd="ls -lFh --color  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M -d *(-/DN)"
        fi
        alias ls='ls -CFlxBh --color --group-directories-first'
        alias l="ls -CFlxBh --color --group-directories-first"
        alias la='ls -CFlxBh --color --group-directories-first -A'

    else
        alias ll="ls -lFh --color=never  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M"
        alias lsd="ls -lFh --color=never  --group-directories-first --time-style=+%Y/%m/%d\ %H:%M -d *(-/DN)"
        alias ls='ls -CFlxBh --color=never --group-directories-first'
        alias l="ls -CFlxBh --color=never --group-directories-first"
        alias la='ls -CFlxBh --color=never --group-directories-first -A'   
    fi


fi

