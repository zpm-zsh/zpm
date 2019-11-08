#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

# ### Core plugins
zpm if ssh                    \
  zpm-zsh/tmux,inline         \


### Compatibility
zpm if termux                 \
  zpm-zsh/termux,async,inline \


### 3party plugins
zpm                                                          \
  zpm-zsh/core-config,inline                                 \
  zpm-zsh/check-deps,inline                                  \
  zpm-zsh/minimal-theme,inline                               \
  zpm-zsh/ls,inline                                          \
  zpm-zsh/colorize,async,inline                              \
  zpm-zsh/ssh,async,inline                                   \
  zpm-zsh/dot,async,inline                                   \
  zpm-zsh/dircolors-material,inline                          \
  zpm-zsh/undollar,async,inline                              \
  zsh-users/zsh-completions,apply:fpath,fpath:/src           \


zpm if-not ssh                                               \
  zpm-zsh/dropbox,async,inline                               \
  lukechilds/zsh-better-npm-completion,async,inline          \
  tj/git-extras,source:/etc/git-extras-completion.zsh,inline \
  horosgrisa/utils,apply:path                                \
                                                             \
  zpm-zsh/readers,async,inline                               \
  zpm-zsh/clipboard,async,inline                             \
  zpm-zsh/mysql-colorize,async,inline                        \
  zpm-zsh/zshmarks,async,inline                              \
  voronkovich/gitignore.plugin.zsh,async,inline              \
  zpm-zsh/autoenv,async,inline                               \
                                                             \
  mdumitru/fancy-ctrl-z,async,inline                         \
  jimhester/per-directory-history,inline                     \
  hlissner/zsh-autopair,async,inline                         \
  psprint/history-search-multi-word,async                    \
  zsh-users/zsh-history-substring-search                     \
  zdharma/fast-syntax-highlighting                           \
  tarruda/zsh-autosuggestions                                \


zpm                                        \
  omz/pip,async,inline                \
  omz/extract,async,inline            \
  omz/command-not-found,async,inline  \
  omz/wp-cli,async,inline             \


if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local 
fi
