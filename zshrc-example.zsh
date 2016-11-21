#!/usr/bin/env zsh

if [[ -f ~/.zpm/zpm.zsh ]]; then
  source ~/.zpm/zpm.zsh
else
  git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
  source ~/.zpm/zpm.zsh
fi

Plug zsh-core human ls cd desktop  #ZSH
Plug colors dircolors  #Colors
Plug user_prompt node git path ps2 eol title  #Prompt
Plug extract tmux readers ssh
Plug horosgrisa/zsh-dropbox horosgrisa/utils  #Programs
### 3party plugins
Plug zsh-users/zsh-completions horosgrisa/autoenv horosgrisa/mysql-colorize jocelynmallon/zshmarks voronkovich/gitignore.plugin.zsh
Plug zsh-users/zsh-syntax-highlighting tarruda/zsh-autosuggestions horosgrisa/zsh-history-substring-search
###
Plug termux check-deps oh-my-zsh-wrapper # Compatibility

plugins=( emoji-clock golang ) # Plugins from oh-my-zsh

# ZSH
PROMPT='$user_prompt'
RPROMPT='$node_version$gitprompt$current_path'
PROMPT2='$ps2'
PROMPT_EOL_MARK='$eol'
TITLE='$program'

[[ -f $HOME/.zshrc.custom ]] && source $HOME/.zshrc.custom || true
