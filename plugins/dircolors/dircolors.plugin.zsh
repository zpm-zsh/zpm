#!/usr/bin/env zsh

if hash dircolors 2>/dev/null; then
    eval $(dircolors ${${(%):-%x}:a:h}/dircolors )
else
    if hash gdircolors 2>/dev/null; then
        eval $(gdircolors ${${(%):-%x}:a:h}/dircolors )
    fi

fi
