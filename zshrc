#!/usr/bin/env zsh

# Set xdg param XDG_DATA_HOME

_ZPM_PLUGIN_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm/zpm.zsh"
source "$_ZPM_PLUGIN_FILE"

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

### iTerm2
zpm if iterm load zpm-zsh/iterm

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
zpm if-not ssh load                                \
  mdumitru/fancy-ctrl-z,async                      \
  voronkovich/gitignore.plugin.zsh,async           \
  zpm-zsh/autoenv,async                            \
  zpm-zsh/bookmarks,async                          \
  zpm-zsh/clipboard                                \
  zpm-zsh/command-not-found,async                  \
  zpm-zsh/dropbox,apply:path:fpath                 \
  zpm-zsh/extract,async                            \
  zpm-zsh/history-search-multi-word,async          \
  zpm-zsh/mysql-colorize,async                     \
  zpm-zsh/rehash-on-usr1,async                     \
  zpm-zsh/tmux-keys                                \
  zpm-zsh/zsh-better-npm-completion,async          \
  zpm-zsh/zsh-completions                          \
  zpm-zsh/zsh-history-substring-search,async       \
  zsh-users/zsh-autosuggestions,async              \
  zpm-zsh/fast-syntax-highlighting,async
