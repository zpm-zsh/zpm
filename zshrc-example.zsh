#!/usr/bin/env zsh

if [[ -f ~/.zpm/zpm.zsh ]]; then
  source ~/.zpm/zpm.zsh
else
  git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
fi

Plug zsh-core human ls cd colors dircolors tmux
Plug desktop node git readers ssh
Plug noempty user-prompt path ps2 eol title
Plug termux check-deps oh-my-zsh-wrapper # Compatibility

# ZSH
PROMPT='$user_prompt'
RPROMPT='$node_version$gitprompt$current_path'
PROMPT2='$ps2'
PROMPT_EOL_MARK='$eol'

[[ -f $HOME/.zshrc.custom ]] && source $HOME/.zshrc.custom || true
