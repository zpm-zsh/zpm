#!/usr/bin/env zsh
typeset -g _ZPM_autoload=()

typeset -ag _ZPM_plugins_for_source
typeset -ag _ZPM_plugins_for_async_source
typeset -ag _ZPM_plugins_no_source

typeset -Ag _ZPM_file_for_source
typeset -Ag _ZPM_file_for_async_source

autoload -Uz zpm
