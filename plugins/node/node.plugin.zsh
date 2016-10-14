#!/usr/bin/env zsh

NODE_VERSION_PREFIX=${NODE_VERSION_PREFIX:-" "}
NODE_VERSION_SUFIX=${NODE_VERSION_SUFIX:-""}


function node-docs {
  local open_cmd
  if [[ "$OSTYPE" = darwin* ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  $open_cmd "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
}

_node_version() {
  if [ -d "./node_modules" -o -d "../node_modules" -o -d "../../node_modules" -o -d "../../../node_modules" ]; then
    if hash node 2>/dev/null; then
      nodev=$(node -v)
      nodev=${nodev#'v'}
      if [[ $COLORS == "true" ]]; then
        node_version="%{$fg_bold[blue]%}$NODE_VERSION_PREFIX$nodev$NODE_VERSION_SUFIX%{$reset_color%}"
      else
        node_version="$NODE_VERSION_PREFIX$nodev$NODE_VERSION_SUFIX"
      fi
    else
      if [[ $COLORS == "true" ]]; then
        node_version="%{$fg[yellow]%}$NODE_VERSION_PREFIX""Node.js not found""$NODE_VERSION_SUFIX%{$reset_color%}"
      else
        node_version="$NODE_VERSION_PREFIX""Node.js not found""$NODE_VERSION_SUFIX"
      fi
    fi
  else
    node_version=""
  fi
}

function install_npm (){
  curl -L https://www.npmjs.com/install.sh | sudo sh
}

precmd_functions+=(_node_version)
DEPENDENCES_ARCH+=( nodejs )
DEPENDENCES_DEBIAN+=( nodejs )
