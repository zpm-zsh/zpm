#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core
zpm if ssh                \
  zpm-zsh/tmux,inline     \


zpm if-not ssh            \
  zpm-zsh/tmux,apply:path \


### Compatibility
zpm if termux                 \
  zpm-zsh/termux,async,inline \


### 3party plugins
zpm                                                          \
  zpm-zsh/core-config,inline                                 \
  zpm-zsh/ignored-users,inline,async                         \
  zpm-zsh/check-deps,inline                                  \
  zpm-zsh/minimal-theme,inline                               \
  zpm-zsh/ls,inline,async                                    \
  zpm-zsh/colorize,async,inline                              \
  zpm-zsh/ssh,async,inline                                   \
  zpm-zsh/dot,async,inline                                   \
  zpm-zsh/dircolors-material,inline,async                    \
  zpm-zsh/undollar,async,inline                              \
  zsh-users/zsh-completions,apply:fpath,fpath:/src           \


zpm if-not ssh                                                                                \
  zpm-zsh/dropbox,async,inline                                                                \
  lukechilds/zsh-better-npm-completion,async,inline                                           \
  tj/git-extras,source:/etc/git-extras-completion.zsh,inline,async                            \
  horosgrisa/utils,apply:path                                                                 \
                                                                                              \
  zpm-zsh/readers,async,inline                                                                \
  zpm-zsh/clipboard,async,inline                                                              \
  zpm-zsh/mysql-colorize,async,inline                                                         \
  zpm-zsh/zshmarks,async,inline                                                               \
  voronkovich/gitignore.plugin.zsh,async,inline                                               \
  zpm-zsh/autoenv,async,inline                                                                \
                                                                                              \
  mdumitru/fancy-ctrl-z,async,inline                                                          \
  hlissner/zsh-autopair,async,inline                                                          \
  zthxxx/zsh-history-enquirer,async,inline                                                    \
  zsh-users/zsh-history-substring-search,source:zsh-history-substring-search.zsh,inline,async \
  zdharma/fast-syntax-highlighting,inline,async                                               \
  tarruda/zsh-autosuggestions,source:zsh-autosuggestions.zsh,inline,async                     \


zpm                                  \
  omz/pip,async,inline               \
  omz/extract,async,inline           \
  omz/command-not-found,async,inline \
  omz/wp-cli,async,inline            \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
