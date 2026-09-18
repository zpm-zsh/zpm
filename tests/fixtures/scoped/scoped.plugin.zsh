#!/usr/bin/env zsh

# Mimics the common top-of-file idiom: a plugin sets options for its own body and
# expects them not to escape into the user's shell.
setopt local_options extended_glob

local scoped_local='inside'
typeset -g ZPM_SCOPED_LOADED=1
