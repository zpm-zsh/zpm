# The addition 'nvm install' attempts in ~/.profile

if [[ -d ~/.linuxbrew ]]; then
  export PATH="/home/user/.linuxbrew/bin:$PATH"
  export MANPATH="/home/user/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/user/.linuxbrew/share/info:$INFOPATH"
elif hash brew 2>/dev/null; then
  #statements
fi


function _brew-upgrade(){
  if hash brew 2>/dev/null; then
    echo ">> Updating hook: brew"
    brew update
  fi
}

if ! hash brew 2>/dev/null; then
  function nvm-install(){
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    export PATH="/home/user/.linuxbrew/bin:$PATH"
    export MANPATH="/home/user/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/user/.linuxbrew/share/info:$INFOPATH"
  }
fi
DEPENDENCES_ARCH+=( curl git python-setuptools ruby )
DEPENDENCES_DEBIAN+=( build-essential curl git python-setuptools ruby )
