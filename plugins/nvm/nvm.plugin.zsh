# The addition 'nvm install' attempts in ~/.profile

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh

function _nvm-upgrade(){
	if [[ -d "$HOME/.nvm/" ]]; then
	    echo ">> Updating hook: nvm"
        git --git-dir="$HOME/.nvm/.git/" --work-tree="$HOME/.nvm/" pull
    fi
}

if ! hash nvm 2>/dev/null; then
    function nvm-install(){
        git clone https://github.com/creationix/nvm ~/.nvm
				[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh
				nvm alias default system
    }
fi
