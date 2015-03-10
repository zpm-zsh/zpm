#!/usr/bin/env zsh

if [[ `lsb_release -is` == 'Ubuntu' ]]; then
    run-parts /etc/update-motd.d/
fi
