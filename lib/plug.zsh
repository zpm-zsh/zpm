#!/usr/bin/env zsh

function Plug(){
  for plugin ($@); do
    _ZPM-initialize-plugin $plugin
  done
}
