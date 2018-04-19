#!/usr/bin/env zsh

DEPENDENCES_ARCH+=( node@nodejs )
DEPENDENCES_DEBIAN+=( node@nodejs )

function install_npm (){
  curl -L https://www.npmjs.com/install.sh | sudo sh
}

NODE_VERSION_PREFIX=${NODE_VERSION_PREFIX:-" "}
NODE_VERSION_SUFIX=${NODE_VERSION_SUFIX:-""}

_node_version_pre() {
  if (( $+commands[node] )); then
    nodev=$(node -v)
    nodev=${nodev#'v'}
    if [[ $COLORS == "true" ]]; then
      node_version_pre="$NODE_VERSION_PREFIX%{$fg_bold[green]%}⬡ %{$fg_bold[blue]%}$nodev%{$reset_color%}$NODE_VERSION_SUFIX"
    else
      node_version_pre="$NODE_VERSION_PREFIX⬡ $nodev$NODE_VERSION_SUFIX"
    fi
  else
    if [[ $COLORS == "true" ]]; then
      node_version_pre="$NODE_VERSION_PREFIX%{$fg[red]%}Node.js not found%{$reset_color%}$NODE_VERSION_SUFIX"
    else
      node_version_pre="$NODE_VERSION_PREFIXNode.js not found$NODE_VERSION_SUFIX"
    fi
  fi
}
_node_version_pre
chpwd_functions+=(_node_version_pre)
periodic_functions+=(_node_version_pre)

_node_version() {
  if $_ZPM_DIR/bin/recursive-exist node_modules >/dev/null; then
    node_version="$node_version_pre"
  else
    node_version=""
  fi

}
precmd_functions+=(_node_version)
