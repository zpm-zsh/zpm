alias tmux="TERM=xterm-256color tmux -2 attach || TERM=xterm-256color tmux -2 -f${0:a:h}/tmux.conf new"

export TMUX_PP="~/.zpm/plugins/tmux/bin/_tmux-resurrect-install"

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -z $TMUX_AUTOSTART  && -n "$SSH_CONNECTION" ]]; then
    TMUX_AUTOSTART="true"
fi

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]
  then
      tmux
      exit 0
  fi
    precmd_functions=(${precmd_functions#_tmux_autostart})
}

function _tmux-update-hook(){
    echo ">> Updating hook: tmux"
    git --git-dir="$HOME/.tmux/plugins/tpm/.git" --work-tree="$HOME/.tmux/plugins/tpm" pull
}

precmd_functions+=( _tmux_autostart )


function _tmux_motd(){
	if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]]; then
		if [[ "$OSTYPE" == linux* ]]; then
			_tmux_monitor
			return 0
		fi
		if [[ "$OSTYPE" == freebsd* ]]; then
			cat /etc/motd
			return 0
		fi
	fi
}

_tmux_motd
