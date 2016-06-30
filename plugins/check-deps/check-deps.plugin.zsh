
function Check-Deps(){
  #Arch System Deps
  if hash pacman 2>/dev/null; then
    local DEPENDENCES_ARCH_MISSING=()
    for i ($DEPENDENCES_ARCH); do
      if (! pacman -Q $i 1>/dev/null 2>/dev/null) ; then
        DEPENDENCES_ARCH_MISSING+=( $i )
      fi
    done
    if [[ ! -z "$DEPENDENCES_ARCH_MISSING" ]]; then
      echo Please install missing packages using \`sudo pacman -S $DEPENDENCES_ARCH_MISSING\`
    fi
  fi

  if hash dpkg 2>/dev/null; then
    DEPENDENCES_DEBIAN_MISSING=()
    DEB_PACKAGES=$(dpkg --list| awk '{print $2}'|awk -F':' '{print $1}')
    for i ($DEPENDENCES_DEBIAN); do
      if [[ ! $(echo $DEPENDENCES_DEBIAN | grep -q $i ) ]]; then
        if [[ ! ${DEPENDENCES_DEBIAN_MISSING[(r)$i]} == $i ]] && DEPENDENCES_DEBIAN_MISSING+=( $i )
      fi
    done
    if [ ! -z "$DEPENDENCES_DEBIAN_MISSING" ]; then
      echo Please install missing packages using \`sudo apt install $DEPENDENCES_DEBIAN_MISSING\`
    fi
  fi

  if hash npm 2>/dev/null; then
    DEPENDENCES_NPM_MISSING=()
    local NPM_PATH="$( npm config get prefix )/lib/node_modules"
    for i ($DEPENDENCES_NPM); do
      if [[ ! -d "$NPM_PATH/$i"  ]] ; then
        if [[ ! ${DEPENDENCES_NPM_MISSING[(r)$i]} == $i ]] && DEPENDENCES_NPM_MISSING+=( $i )
      fi
    done
    if [ ! -z "$DEPENDENCES_NPM_MISSING" ]; then
      echo Please install missing packages using \`sudo npm install -g $DEPENDENCES_NPM_MISSING\`
    fi
  fi
}

function _check_deps(){
  Check-Deps
  precmd_functions=(${precmd_functions#_check_deps})
}

if [[ "$CHECK_DEPS_AT_START" != "false" && $(\ls -di / |awk -F' ' '{print $1}') == "2" ]]; then
  precmd_functions+=( _check_deps )
fi
