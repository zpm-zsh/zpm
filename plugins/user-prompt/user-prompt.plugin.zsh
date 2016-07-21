user_PROMPT_ROOT=${user_PROMPT_ROOT:-'#'}
user_PROMPT_USER=${user_PROMPT_USER:-'$'}
user_PROMPT_PREFIX=${user_PROMPT_PREFIX:-" "}
user_PROMPT_SUFIX=${user_PROMPT_SUFIX:-" "}


_user_prompt() {
  if [[ "$EUID" == 0 ]]; then
    if [[ $COLORS == "true" ]]; then
      export user_prompt="%{$fg[red]%}$user_PROMPT_PREFIX$user_PROMPT_ROOT$user_PROMPT_SUFIX%{$reset_color%}"
    else
      export user_prompt="$user_PROMPT_PREFIX$user_PROMPT_ROOT$user_PROMPT_SUFIX"
    fi
  else
    if [[ $COLORS == "true" ]]; then
      export user_prompt="%{$fg[yellow]%}$user_PROMPT_PREFIX$user_PROMPT_USER$user_PROMPT_SUFIX%{$reset_color%}"
    else
      export user_prompt="$user_PROMPT_PREFIX$user_PROMPT_USER$user_PROMPT_SUFIX"
    fi
  fi
}

precmd_functions+=(_user_prompt)
