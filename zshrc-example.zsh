#!/usr/bin/env zsh

if [[ -f /usr/share/zpm/zpm.zsh ]]; then # If you use zpm from package
	source /usr/share/zpm/zpm.zsh
elif [[ -f ~/.zpm/zpm.zsh ]]; then # If you use zpm from git
	source ~/.zpm/zpm.zsh
else
	git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm # If you don't have zpm
	source ~/.zpm/zpm.zsh
fi

Plug termux command-not-found check-deps  # Compatibility
Plug zsh-core human ls cd hosts desktop  #ZSH
Plug colors dircolors  #Colors
Plug left-prompt node status path git  #Prompt
Plug myip extract tmux genpasswd readers rmate horosgrisa/zsh-dropbox horosgrisa/utils  #Programs
Plug nvm  #Package managers
Plug zsh-users/zsh-completions horosgrisa/autoenv horosgrisa/mysql-colorize jocelynmallon/zshmarks
Plug voronkovich/gitignore.plugin.zsh zsh-users/zsh-syntax-highlighting horosgrisa/zsh-history-substring-search tarruda/zsh-autosuggestions
Plug oh-my-zsh-wrapper  # Wrapper for oh-my-zsh

plugins=( emoji-clock golang ) # Plugins from oh-my-zsh

# ZSH
PROMPT='$left_prompt'
RPROMPT=' $last_status$node_version$gitprompt$current_path%{$reset_color%}'
PS2="%{$fg[green]%}%_>%{$reset_color%}"
PROMPT_EOL_MARK="%{$bg[cyan]%}%{$fg[white]%}⏎%{$reset_color%}"
WORDCHARS='*?_-~=&;!#$%^()[]{}<>:.'

#################
###  Plugins  ###
#################

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_STYLES[cursor]='fg=inverse'

ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=green,bold'

ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'

ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=white,bg=red'

ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
ZSH_HIGHLIGHT_STYLES[default]='fg=cyan,bold'

ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('\|' 'fg=red,bold')
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)

# zshmarks
alias mark='bookmark'
alias c='jump'
alias marks='showmarks'
alias delmark='deletemark'

# colors
PYGMENTIZE_THEME=monokai

[[ -f $HOME/.zshrc.custom ]] && source $HOME/.zshrc.custom || true
