#!/usr/bin/env zsh

if [[ -d ~/.linuxbrew ]]; then
  export PATH="/home/user/.linuxbrew/bin:$PATH"
  export MANPATH="/home/user/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/user/.linuxbrew/share/info:$INFOPATH"
fi


function _brew-upgrade(){
  if (( $+commands[brew] )); then
    echo ">> Updating hook: brew"
    brew update
  fi
}

if ! (( $+commands[brew] )); then
  function brew-install(){
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    export PATH="/home/user/.linuxbrew/bin:$PATH"
    export MANPATH="/home/user/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/user/.linuxbrew/share/info:$INFOPATH"
  }
fi
DEPENDENCES_ARCH+=( curl git easy_install@python-setuptools ruby )
DEPENDENCES_DEBIAN+=( make@build-essential curl git easy_install@python-setuptools ruby )
