#!/usr/bin/env zsh

function Check-Deps(){
  #Arch System Deps
  if (( $+commands[pacman] )); then
    local DEPENDENCES_ARCH_MISSING=()
    for i ($DEPENDENCES_ARCH); do
      if [[ "$i" == *@* ]]; then
        executable=$(echo -n $i|awk -F'@' '{print $1}')
        package=$(echo -n $i|awk -F'@' '{print $2}')
      else
        package="$i"
        executable="$i"
      fi
      if (! hash $executable 1>/dev/null 2>/dev/null) ; then
        DEPENDENCES_ARCH_MISSING+=( $package )
      fi
    done
    if [[ ! -z "$DEPENDENCES_ARCH_MISSING" ]]; then
      echo "Please install missing packages using \`sudo pacman -S $DEPENDENCES_ARCH_MISSING\`"
    fi
  fi
  
  if (( $+commands[dpkg] )); then
    DEPENDENCES_DEBIAN_MISSING=()
    _DEB_packageS="$(dpkg --list|awk '{print $2}'|awk -F':' '{print $1}'|xargs)"
    for i ($DEPENDENCES_DEBIAN); do
      if [[ "$i" == *@* ]]; then
        executable=$(echo -n $i|awk -F'@' '{print $1}')
        package=$(echo -n $i|awk -F'@' '{print $2}')
      else
        package="$i"
        executable="$i"
      fi
      if (! hash $executable 1>/dev/null 2>/dev/null) ; then
        DEPENDENCES_DEBIAN_MISSING+=( $package )
      fi
    done
    if [ ! -z "$DEPENDENCES_DEBIAN_MISSING" ]; then
      echo "Please install missing packages using \`sudo apt install $DEPENDENCES_DEBIAN_MISSING\`"
    fi
  fi
  
  if (( $+commands[npm] )); then
    DEPENDENCES_NPM_MISSING=()
    for i ($DEPENDENCES_NPM); do
      if [[ "$i" == *@* ]]; then
        executable=$(echo -n $i|awk -F'@' '{print $1}')
        package=$(echo -n $i|awk -F'@' '{print $2}')
      else
        package="$i"
        executable="$i"
      fi
      if (! hash $executable 1>/dev/null 2>/dev/null) ; then
        DEPENDENCES_NPM_MISSING+=( $package )
      fi
    done
    if [ ! -z "$DEPENDENCES_NPM_MISSING" ]; then
      echo "Please install missing packages using \`sudo npm install -g $DEPENDENCES_NPM_MISSING\`"
    fi
  fi
}

function _check_deps(){
  Check-Deps
  precmd_functions=(${precmd_functions#_check_deps})
}

if [[ "$CHECK_DEPS_AT_START" != "false" ]]; then
  precmd_functions+=( _check_deps )
fi
