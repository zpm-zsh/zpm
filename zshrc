#!/usr/bin/env zsh
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --depth 1 https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Tmux
zpm if ssh load zpm-zsh/tmux
zpm if-not ssh load zpm-zsh/tmux,apply:path

### Compatibility
zpm if termux load     \
  zpm-zsh/termux,async \


zpm if vte load \
  zpm-zsh/vte   \


### 3party plugins
zpm load                                           \
  zpm-zsh/core-config                              \
  zpm-zsh/ignored-users,async                      \
  zpm-zsh/check-deps                               \
  zpm-zsh/minimal-theme                            \
  zpm-zsh/ls,async                                 \
  zpm-zsh/colorize,async                           \
  zpm-zsh/ssh,async                                \
  zpm-zsh/dot,async                                \
  zpm-zsh/dircolors-material,async                 \
  zpm-zsh/undollar,async                           \
  zsh-users/zsh-completions,apply:fpath,fpath:/src \


zpm if-not ssh load                                                                    \
  zpm-zsh/dropbox,async                                                                \
  lukechilds/zsh-better-npm-completion,async                                           \
                                                                                       \
  zpm-zsh/readers,async                                                                \
  zpm-zsh/clipboard,async                                                              \
  zpm-zsh/mysql-colorize,async                                                         \
  zpm-zsh/zshmarks,async                                                               \
  voronkovich/gitignore.plugin.zsh,async                                               \
  zpm-zsh/autoenv,async                                                                \
                                                                                       \
  mdumitru/fancy-ctrl-z,async                                                          \
  zthxxx/zsh-history-enquirer,async                                                    \
  zsh-users/zsh-history-substring-search,source:zsh-history-substring-search.zsh,async \
  zdharma/fast-syntax-highlighting,async                                               \
  zsh-users/zsh-autosuggestions,source:zsh-autosuggestions.zsh,async                   \


zpm load                      \
  omz/extract,async           \
  omz/command-not-found,async \
  omz/wp-cli,async            \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
