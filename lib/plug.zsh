#!/usr/bin/env zsh

function Plug(){
  for plugin ($@); do
    _ZPM_Initialize_Plugin $plugin
  done
}