#!/usr/bin/env zsh
if hash dircolors 2>/dev/null; then
    eval $(dircolors ${${(%):-%x}:a:h}/dircolors.simple )
else
    if hash gdircolors 2>/dev/null; then
        eval $(gdircolors ${${(%):-%x}:a:h}/dircolors.simple )
    fi

fi
