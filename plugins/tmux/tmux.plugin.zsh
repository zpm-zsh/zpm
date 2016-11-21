alias tmux="TERM=xterm-256color tmux -2 attach || TERM=xterm-256color tmux -2 -f${${(%):-%x}:a:h}/tmux.conf new"


if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -z $TMUX_AUTOSTART  && -n "$SSH_CONNECTION" ]]; then
  if hash tmux 2>/dev/null; then
    TMUX_AUTOSTART="true"
  fi
fi

function _tmux-upgrade(){
  echo ">> Updating hook: tmux"
  git --git-dir="$HOME/.tmux/plugins/tpm/.git" --work-tree="$HOME/.tmux/plugins/tpm" pull
}

precmd_functions+=( _tmux_autostart )

if [[ ! -z $TMUX ]]; then
  function _tmux_refresh(){
    \tmux refresh-client -S
  }
  chpwd_functions+=( _tmux_refresh ) 
fi

function _tmux_motd(){
  if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && ( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
    if [[ "$OSTYPE" == linux* || "$OSTYPE" == freebsd*  ]]; then
      _tmux_monitor
      return 0
    fi
  fi
}


if [[ $TMUX_MOTD != false ]]; then
  _tmux_motd
fi
DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )
