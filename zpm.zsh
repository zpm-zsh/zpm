#!/usr/bin/env zsh


source ${${(%):-%x}:a:h}/lib/core.zsh

source ${${(%):-%x}:a:h}/lib/functions.zsh
source ${${(%):-%x}:a:h}/lib/initialize.zsh
source ${${(%):-%x}:a:h}/lib/upgrade.zsh

source ${${(%):-%x}:a:h}/lib/completion.zsh

zpm zpm-zsh/helpers zpm-zsh/colors
