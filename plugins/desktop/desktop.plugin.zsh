#!/usr/bin/env zsh

source ${${(%):-%x}:a:h}/clipboard.plugin.zsh

alias night="xgamma -rgamma 0.64 -ggamma 0.51 -bgamma 0.69"
alias day="xgamma -rgamma 1 -ggamma 1 -bgamma 1"
alias off='xset dpms force off'
