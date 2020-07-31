#!/usr/bin/env zsh
source ~/.zpm/zpm.zsh 2>/dev/null || {
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
}

### Tmux
zpm if ssh load zpm-zsh/tmux
zpm if-not ssh load zpm-zsh/tmux,apply:path

### VTE
zpm if vte load zpm-zsh/vte

### 3party plugins
zpm load                              \
  zpm-zsh/core-config                 \
  zpm-zsh/ignored-users,async         \
  zpm-zsh/check-deps,async            \
  zpm-zsh/minimal-theme               \
  zpm-zsh/ls,async                    \
  zpm-zsh/colorize,async              \
  zpm-zsh/ssh,async                   \
  zpm-zsh/dot,async                   \
  zpm-zsh/undollar,async              \
  zpm-zsh/zsh-completions,apply:fpath

### Plugins for local host
zpm if-not ssh load                                                                    \
  zpm-zsh/dropbox,async                                                                \
  lukechilds/zsh-better-npm-completion,async                                           \
                                                                                       \
  zpm-zsh/clipboard                                                                    \
  zpm-zsh/mysql-colorize,async                                                         \
  zpm-zsh/zshmarks,async                                                               \
  voronkovich/gitignore.plugin.zsh,async                                               \
  zpm-zsh/autoenv,async                                                                \
                                                                                       \
  mdumitru/fancy-ctrl-z,async                                                          \
  zsh-users/zsh-history-substring-search,source:zsh-history-substring-search.zsh,async \
  zdharma/fast-syntax-highlighting,async                                               \
  zsh-users/zsh-autosuggestions,source:zsh-autosuggestions.zsh,async                   \
  psprint/history-search-multi-word,fpath:/,async

source ~/.zshrc.local 2>/dev/null
