#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core plugins
zpm                     \
  zpm-zsh/core-config   \
  zpm-zsh/check-deps    \


### Compatibility
zpm if termux           \
  zpm-zsh/termux        \


### 3party plugins
zpm                                          \
  zpm-zsh/minimal-theme                      \
  zpm-zsh/ls                                 \
  zpm-zsh/tmux                               \
  zpm-zsh/colorize                           \
  zpm-zsh/ssh                                \
  zpm-zsh/dot                                \
  zpm-zsh/dircolors-material                 \
  zpm-zsh/undollar                           \
  zsh-users/zsh-completions,fpath-only:/src  \


zpm if-not ssh                       \
  zpm-zsh/readers                    \
  zpm-zsh/clipboard                  \
  zpm-zsh/autoenv                    \
  zpm-zsh/mysql-colorize             \
  jocelynmallon/zshmarks             \
  voronkovich/gitignore.plugin.zsh   \
  psprint/history-search-multi-word  \
  zdharma/fast-syntax-highlighting   \
  tarruda/zsh-autosuggestions        \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
