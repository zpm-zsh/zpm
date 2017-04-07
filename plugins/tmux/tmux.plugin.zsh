alias tmux="TERM=xterm-256color tmux -2 attach || TERM=xterm-256color tmux -2 -f${${(%):-%x}:a:h}/tmux.conf new"


if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm </dev/null >/dev/null 2>/dev/null &!
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

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    exec env TERM=xterm-256color tmux -2 -f/home/grisa/.zpm/plugins/tmux/tmux.conf new
  fi
  precmd_functions=(${precmd_functions#_tmux_autostart})
}

precmd_functions+=( _tmux_autostart )

function _tmux_motd(){
  if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && ( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
    if [[ "$OSTYPE" == linux* || "$OSTYPE" == freebsd*  ]]; then
      _tmux_monitor
      return 0
    fi
  fi
}


if [[ $TMUX_AUTOSTART == true ]]; then
  _tmux_motd
fi
DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )
