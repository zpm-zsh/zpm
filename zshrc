#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

# zpm a/b,apply:async

### Core plugins
zpm                     \
  zpm-zsh/core-config   \
  zpm-zsh/check-deps    \


### Compatibility
zpm if termux           \
  zpm-zsh/termux,apply:async        \


### 3party plugins
zpm                                                 \
  zpm-zsh/minimal-theme                             \
  zpm-zsh/ls                                        \
  zpm-zsh/tmux                                      \
  zpm-zsh/colorize,apply:async                                  \
  zpm-zsh/ssh,apply:async                                       \
  zpm-zsh/dot,apply:async                                       \
  zpm-zsh/dircolors-material,apply:async                        \
  zpm-zsh/undollar,apply:async                                  \
  zsh-users/zsh-completions,apply:fpath,fpath:/src  \


zpm if-not ssh                       \
  zpm-zsh/readers,apply:async                    \
  zpm-zsh/clipboard,apply:async                  \
  zpm-zsh/autoenv                    \
  zpm-zsh/mysql-colorize,apply:async             \
  zpm-zsh/zshmarks,apply:async                   \
  voronkovich/gitignore.plugin.zsh,apply:async   \
  psprint/history-search-multi-word  \
  zdharma/fast-syntax-highlighting   \
  tarruda/zsh-autosuggestions        \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
