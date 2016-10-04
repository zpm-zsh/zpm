
USER_PROMPT_ROOT=${USER_PROMPT_ROOT:-'#'}
USER_PROMPT_USER=${USER_PROMPT_USER:-'$'}
USER_PROMPT_PREFIX=${USER_PROMPT_PREFIX:-" "}
USER_PROMPT_SUFIX=${USER_PROMPT_SUFIX:-" "}


_user_prompt() {
  if [[ "$EUID" == 0 ]]; then
    if [[ $COLORS == "true" ]]; then
      export user_prompt="%{$fg[red]%}$USER_PROMPT_PREFIX$USER_PROMPT_ROOT$USER_PROMPT_SUFIX%{$reset_color%}"
    else
      export user_prompt="$USER_PROMPT_PREFIX$USER_PROMPT_ROOT$USER_PROMPT_SUFIX"
    fi
  else
    if [[ $COLORS == "true" ]]; then
      export user_prompt="%{$fg[yellow]%}$USER_PROMPT_PREFIX$USER_PROMPT_USER$USER_PROMPT_SUFIX%{$reset_color%}"
    else
      export user_prompt="$USER_PROMPT_PREFIX$USER_PROMPT_USER$USER_PROMPT_SUFIX"
    fi
  fi
}

precmd_functions+=(_user_prompt)
