#!/usr/bin/env zsh
PR_PROMPT_PREFIX=${PR_PROMPT_PREFIX:-' '}
PR_PROMPT_SUFIX=${PR_PROMPT_SUFIX:-''}

_pr_user() {
  local RETVAL=$?
  if [[ $CLICOLOR = 1 ]]; then
    if [ $RETVAL -eq 0 ]; then
      pr_user="$PR_PROMPT_PREFIX%{$fg_bold[yellow]%}"'$'"%{$reset_color%}$PR_PROMPT_SUFIX"
    else
      pr_user="$PR_PROMPT_PREFIX%{$fg_bold[red]%}"'$'"%{$reset_color%}$PR_PROMPT_SUFIX"
    fi
  else
    if [ $RETVAL -eq 0 ]; then
      pr_user="$PR_PROMPT_PREFIX+$PR_PROMPT_SUFIX"
    else
      pr_user="$PR_PROMPT_PREFIX-$PR_PROMPT_SUFIX"
    fi
  fi
}

precmd_functions+=(_pr_user)
