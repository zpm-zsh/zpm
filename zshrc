#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core plugins
zpm zpm-zsh/core-config
zpm zpm-zsh/check-deps
zpm load-if termux zpm-zsh/termux # Compatibility

### 3party plugins
zpm zpm-zsh/ls
zpm zpm-zsh/tmux
zpm zpm-zsh/colorize
zpm zpm-zsh/ssh
zpm zpm-zsh/dot
zpm zpm-zsh/dircolors-material
zpm zpm-zsh/undollar
zpm zsh-users/zsh-completions

zpm load-if-not ssh zpm-zsh/readers zpm-zsh/clipboard
zpm load-if-not ssh zpm-zsh/autoenv
zpm load-if-not ssh zpm-zsh/mysql-colorize

zpm load-if-not ssh jocelynmallon/zshmarks
zpm load-if-not ssh voronkovich/gitignore.plugin.zsh
zpm load-if-not ssh psprint/history-search-multi-word
zpm load-if-not ssh zdharma/fast-syntax-highlighting
zpm load-if-not ssh tarruda/zsh-autosuggestions

zpm zpm-zsh/minimal-theme

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
