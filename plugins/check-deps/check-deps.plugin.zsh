function Check-Deps(){
  #Arch System Deps
  if hash pacman 2>/dev/null; then
    local DEPENDENCES_ARCH_MISSING=()
    for i ($DEPENDENCES_ARCH); do
      if (! pacman -Q $i 1>/dev/null 2>/dev/null) ; then
        DEPENDENCES_ARCH_MISSING+=$i
      fi
    done
    if [[ ! -z "$DEPENDENCES_ARCH_MISSING" ]]; then
      echo Please install missing packages using \`sudo pacman -S $DEPENDENCES_ARCH_MISSING\`
    fi
  fi

# NPM Deps
  if hash npm 2>/dev/null; then
    local DEPENDENCES_NPM_MISSING=()
    local NPM_PATH="$( npm config get prefix )/lib/node_modules"
    if [[ -d "$NPM_PATH" ]]; then
      for i ($DEPENDENCES_NPM); do
        if [[ ! -d "$NPM_PATH/$i"  ]] ; then
          DEPENDENCES_NPM_MISSING+=$i
        fi
      done
      if [[ ! -z "$DEPENDENCES_NPM_MISSING" ]]; then
        echo Please install missing packages using \`npm i -g $DEPENDENCES_NPM_MISSING\`
      fi
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
