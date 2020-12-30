#!/usr/bin/env zsh
typeset -g _ZPM_autoload=()

typeset -ag _ZPM_plugins_for_source
typeset -ag _ZPM_plugins_for_async_source
typeset -ag _ZPM_plugins_no_source

typeset -Ag _ZPM_file_for_source
typeset -Ag _ZPM_file_for_async_source

autoload -Uz \
  @zpm-add-autoload \
  @zpm-addfpath \
  @zpm-addpath \
  @zpm-async-source \
  @zpm-background-initialization \
  @zpm-clean \
  @zpm-compile \
  @zpm-get-plugin-autoload \
  @zpm-get-plugin-basename \
  @zpm-get-plugin-bin-path \
  @zpm-get-plugin-file-path \
  @zpm-get-plugin-functions-path \
  @zpm-get-plugin-git-root-path \
  @zpm-get-plugin-git-url \
  @zpm-get-plugin-hyperlink \
  @zpm-get-plugin-link \
  @zpm-get-plugin-name \
  @zpm-get-plugin-path \
  @zpm-get-plugin-type \
  @zpm-initialize-plugin \
  @zpm-launch-plugin-helper \
  @zpm-load-plugins \
  @zpm-log \
  @zpm-no-source \
  @zpm-source \
  @zpm-upgrade \
  zpm
