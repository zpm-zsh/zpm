#!/usr/bin/env zsh

if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
elif [[ -f /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found
fi
