#!/usr/bin/env zsh

if [[ -f ~/.zpm/zpm.zsh ]]; then
  source ~/.zpm/zpm.zsh
else
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
fi

Plug termux check-deps oh-my-zsh-wrapper # Compatibility

[[ -f $HOME/.zshrc.custom ]] && source $HOME/.zshrc.custom || true
