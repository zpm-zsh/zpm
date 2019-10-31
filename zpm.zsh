#!/usr/bin/env zsh

rm ~/.zsh.cache
touch ~/.zsh.cache



source ${${(%):-%x}:a:h}/lib/pre.zsh
source ${${(%):-%x}:a:h}/lib/functions.zsh
source ${${(%):-%x}:a:h}/lib/initialize.zsh
source ${${(%):-%x}:a:h}/lib/upgrade.zsh
source ${${(%):-%x}:a:h}/lib/core.zsh
source ${${(%):-%x}:a:h}/lib/completion.zsh
source ${${(%):-%x}:a:h}/lib/compile.zsh
source ${${(%):-%x}:a:h}/lib/post.zsh
