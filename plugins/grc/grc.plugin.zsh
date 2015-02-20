#!/usr/bin/env zsh

if hash grc 2>/dev/null; then
  for c in ping diff uptime mount lsmod ps df du netstat; do
    alias ${c}="grc --config=${0:a:h}/conf.other $(whence ${c})"
  done
  alias ifconfig="grc --config=${0:a:h}/conf.ifconfig $(whence ifconfig)"
  alias cal="grc --config=${0:a:h}/conf.cal $(whence cal)"
fi
