# The addition 'nvm install' attempts in ~/.profile

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh

function _nvm-update-hook(){
	echo ">> Updating hook: nvm"
    git --git-dir="$HOME/.nvm/.git/" --work-tree="$HOME/.nvm/" pull

}
