#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core plugins
zpm                     \
  zpm-zsh/core-config   \
  zpm-zsh/check-deps    \


### Compatibility
zpm if termux           \
  zpm-zsh/termux,async  \


### 3party plugins
zpm                                                 \
  zpm-zsh/minimal-theme                             \
  zpm-zsh/ls                                        \
  zpm-zsh/colorize,async                            \
  zpm-zsh/ssh,async                                 \
  zpm-zsh/dot,async                                 \
  zpm-zsh/dircolors-material                        \
  zpm-zsh/undollar,async                            \
  zsh-users/zsh-completions,apply:fpath,fpath:/src  \


zpm if ssh                                          \
  zpm-zsh/tmux                                      \


zpm if-not ssh                             \
  zpm-zsh/readers,async                    \
  zpm-zsh/clipboard,async                  \
  zpm-zsh/autoenv                          \
  zpm-zsh/mysql-colorize,async             \
  zpm-zsh/zshmarks,async                   \
  voronkovich/gitignore.plugin.zsh,async   \
  psprint/history-search-multi-word,async  \
  zdharma/fast-syntax-highlighting         \
  tarruda/zsh-autosuggestions              \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
