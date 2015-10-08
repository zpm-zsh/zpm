#!/usr/bin/env zsh

if hash grc 2>/dev/null; then
  for c in ping diff uptime mount free lsmod ps df du netstat; do
    alias ${c}="grc --config=${${(%):-%x}:a:h}/conf.other $(whence ${c})"
  done
  alias ifconfig="grc --config=${${(%):-%x}:a:h}/conf.ifconfig $(whence ifconfig)"
  alias cal="grc --config=${${(%):-%x}:a:h}/conf.cal $(whence cal)"
fi
