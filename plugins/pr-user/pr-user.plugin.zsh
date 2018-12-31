#!/usr/bin/env zsh
USER_PROMPT_ROOT=${USER_PROMPT_ROOT:-'#'}
USER_PROMPT_USER=${USER_PROMPT_USER:-'$'}
USER_PROMPT_PREFIX=${USER_PROMPT_PREFIX:-''}
USER_PROMPT_SUFIX=${USER_PROMPT_SUFIX:-' '}

_pr_user() {
  local RETVAL=$?
  local symbol=''
  local prefix=''
  if [[ "$EUID" == 0 ]]; then
    symbol="$USER_PROMPT_ROOT"
  else
    symbol="$USER_PROMPT_USER"
  fi
  if [[ $CLICOLOR = 1 ]]; then
    if [ $RETVAL -eq 0 ]; then
      prefix="$USER_PROMPT_PREFIX %{$fg_bold[yellow]%}"
    else
      prefix="$USER_PROMPT_PREFIX %{$fg_bold[red]%}"
    fi
  else
    if [ $RETVAL -eq 0 ]; then
      prefix="$USER_PROMPT_PREFIX+"
    else
      prefix="$USER_PROMPT_PREFIX-"
    fi
  fi
  if [[ $CLICOLOR = 1 ]]; then
    pr_user="$prefix$symbol%{$reset_color%}$USER_PROMPT_SUFIX"
  else
    pr_user="$prefix$symbol$USER_PROMPT_SUFIX"
  fi
}

precmd_functions+=(_pr_user)
