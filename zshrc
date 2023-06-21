#!/usr/bin/env zsh

source ~/.zpm/zpm.zsh 2>/dev/null || {
  git clone https://github.com/zpm-zsh/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
}

### OpenWrt
zpm if openwrt load zpm-zsh/openwrt

### Termux
zpm if termux load zpm-zsh/termux

### Tmux
zpm if ssh load zpm-zsh/tmux
zpm if-not ssh load zpm-zsh/tmux,apply:path

### VTE
zpm if vte load zpm-zsh/vte

### MSYS
zpm if msys load zpm-zsh/msys

### VSCode
zpm if vscode load zpm-zsh/vscode

### 3party plugins
zpm load                          \
  zpm-zsh/core-config             \
  zpm-zsh/ignored-users,async     \
  zpm-zsh/check-deps,async        \
  zpm-zsh/minimal-theme           \
  zpm-zsh/dircolors-neutral,async \
  zpm-zsh/fsh-theme-neutral,async \
  zpm-zsh/ls,async                \
  zpm-zsh/colorize,async          \
  zpm-zsh/ssh,async               \
  zpm-zsh/dot,async               \
  zpm-zsh/undollar,async

### Plugins for local host
zpm if-not ssh load                          \
  zpm-zsh/dropbox,apply:path:fpath           \
  zpm-zsh/zsh-better-npm-completion,async    \
  \
  zpm-zsh/clipboard                          \
  zpm-zsh/mysql-colorize,async               \
  zpm-zsh/bookmarks,async                    \
  voronkovich/gitignore.plugin.zsh,async     \
  zpm-zsh/autoenv,async                      \
  \
  mdumitru/fancy-ctrl-z,async                \
  zpm-zsh/zsh-history-substring-search,async \
  zsh-users/zsh-autosuggestions,async        \
  zpm-zsh/fast-syntax-highlighting,async     \
  zpm-zsh/history-search-multi-word,async

source ~/.zshrc.local 2>/dev/null
