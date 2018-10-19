#!/usr/bin/env zsh

DEPENDENCES_ARCH+=( node@nodejs )
DEPENDENCES_DEBIAN+=( node@nodejs )

NODE_VERSION_PREFIX=${NODE_VERSION_PREFIX:-" "}
NODE_VERSION_SUFIX=${NODE_VERSION_SUFIX:-""}

_node_version_pre() {
  
  if (( $+commands[node] )); then
    if _ZPM-recursive-exist node_modules >/dev/null ; then
      nodev=$(node -v)
      nodev=${nodev#'v'}
      if [[ $COLORS == "true" ]]; then
        pr_node="$NODE_VERSION_PREFIX%{$fg_bold[green]%}⬡ %{$fg_bold[blue]%}$nodev%{$reset_color%}$NODE_VERSION_SUFIX"
      else
        pr_node="$NODE_VERSION_PREFIX⬡ $nodev$NODE_VERSION_SUFIX"
      fi
    else
      pr_node=""
    fi
  else
    pr_node=""
  fi
  
}
chpwd_functions+=(_node_version_pre)
periodic_functions+=(_node_version_pre)
