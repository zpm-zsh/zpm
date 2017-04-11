#!/usr/bin/env zsh

if [[ -f ~/.zpm/zpm.zsh ]]; then
  source ~/.zpm/zpm.zsh
else
  git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
fi

Plug zsh-core human ls cd colors dircolors tmux
Plug desktop node git readers ssh
Plug noempty user_prompt path ps2 eol title
### 3party plugins
Plug zsh-users/zsh-completions horosgrisa/autoenv 
Plug horosgrisa/mysql-colorize horosgrisa/zsh-dropbox
Plug jocelynmallon/zshmarks voronkovich/gitignore.plugin.zsh 
Plug psprint/history-search-multi-word
Plug zdharma/fast-syntax-highlighting tarruda/zsh-autosuggestions horosgrisa/utils
###
Plug termux check-deps oh-my-zsh-wrapper # Compatibility

plugins=( emoji-clock ) # Plugins from oh-my-zsh

# ZSH
PROMPT='$user_prompt'
RPROMPT='$node_version$gitprompt$current_path'
PROMPT2='$ps2'
PROMPT_EOL_MARK='$eol'

[[ -f $HOME/.zshrc.custom ]] && source $HOME/.zshrc.custom || true
