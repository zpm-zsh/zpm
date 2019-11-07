#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core plugins
zpm if ssh              \
  zpm-zsh/tmux          \


### Compatibility
zpm if termux           \
  zpm-zsh/termux,async  \


### 3party plugins
zpm                                                   \
  zpm-zsh/core-config                                 \
  zpm-zsh/check-deps                                  \
  zpm-zsh/minimal-theme                               \
  zpm-zsh/ls                                          \
  zpm-zsh/colorize,async                              \
  zpm-zsh/ssh,async                                   \
  zpm-zsh/dot,async                                   \
  zpm-zsh/dircolors-material                          \
  zpm-zsh/undollar,async                              \
  zsh-users/zsh-completions,apply:fpath,fpath:/src    \


zpm if-not ssh                                        \
  zpm-zsh/dropbox,async                               \
  lukechilds/zsh-better-npm-completion,async          \
  tj/git-extras,source:/etc/git-extras-completion.zsh \
  horosgrisa/utils,async                              \
                                                      \
  zpm-zsh/readers,async                               \
  zpm-zsh/clipboard,async                             \
  zpm-zsh/mysql-colorize,async                        \
  zpm-zsh/zshmarks,async                              \
  voronkovich/gitignore.plugin.zsh,async              \
  zpm-zsh/autoenv,async                               \
                                                      \
  mdumitru/fancy-ctrl-z,async                         \
  jimhester/per-directory-history                     \
  hlissner/zsh-autopair,async                         \
  psprint/history-search-multi-word,async             \
  zsh-users/zsh-history-substring-search              \
  zdharma/fast-syntax-highlighting                    \
  tarruda/zsh-autosuggestions                         \


zpm                                 \
  pip,type:omz,async                \
  extract,type:omz,async            \
  command-not-found,type:omz,async  \
  wp-cli,type:omz,async             \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
