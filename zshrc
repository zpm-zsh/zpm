#!/usr/bin/env zsh

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core plugins
zpm zsh-core path-fix check-deps

zpm pr-jobs pr-is-root pr-user # PROMPT 
zpm pr-exec-time pr-cwd # RPROMPT
zpm pr-2 # PROMPT2
zpm pr-eol # PROMPT_EOL_MARK
zpm zpm-zsh/title # PROMPT_TITLE


### 3party plugins
zpm zpm-zsh/ls
zpm zpm-zsh/tmux
zpm zpm-zsh/colors
zpm zpm-zsh/ssh
zpm zpm-zsh/dot
zpm zpm-zsh/dircolors-material
zpm zpm-zsh/history-substring-search-wrapper
zpm zsh-users/zsh-completions

zpm horosgrisa/utils

#################
###  Plugins  ###
#################

# ZSH
PROMPT='$pr_jobs$pr_is_root$pr_user '
RPROMPT='$pr_exec_time$pr_node$pr_git$pr_cwd'
PROMPT2='$pr_2'
PROMPT_EOL_MARK='$pr_eol'
PROMPT_TITLE='$USER@$HOST:$PWD'

