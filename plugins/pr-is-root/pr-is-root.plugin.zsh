#!/usr/bin/env zsh
PR_IS_ROOT_PREFIX=${PR_IS_ROOT_PREFIX:-' '}
PR_IS_ROOT_SUFFIX=${PR_IS_ROOT_SUFFIX:-''}

_pr_is_root() {
  local RETVAL=$?
  pr_is_root=""
  
  if [[ "$EUID" == 0 ]]; then
    
    if [[ $CLICOLOR = 1 ]]; then
      pr_is_root="$PR_IS_ROOT_PREFIX%{$fg_bold[red]%}root%{$reset_color%}$PR_IS_ROOT_SUFFIX"
    else
      pr_is_root="$PR_IS_ROOT_PREFIX""root$PR_IS_ROOT_SUFFIX"
    fi
  fi
}

precmd_functions+=(_pr_is_root)
