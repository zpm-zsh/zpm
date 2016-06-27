LEFT_PROMPT_ROOT=${LEFT_PROMPT_ROOT:-'#'}
LEFT_PROMPT_USER=${LEFT_PROMPT_USER:-'$'}
LEFT_PROMPT_PREFIX=${LEFT_PROMPT_PREFIX:-" "}
LEFT_PROMPT_SUFIX=${LEFT_PROMPT_SUFIX:-" "}


_left_prompt() {
  if [[ "$EUID" == 0 ]]; then
    if [[ $COLORS == "true" ]]; then
      export left_prompt="%{$fg[red]%}$LEFT_PROMPT_PREFIX$LEFT_PROMPT_ROOT$LEFT_PROMPT_SUFIX%{$reset_color%}"
    else
      export left_prompt="$LEFT_PROMPT_PREFIX$LEFT_PROMPT_ROOT$LEFT_PROMPT_SUFIX"
    fi
  else
    if [[ $COLORS == "true" ]]; then
      export left_prompt="%{$fg[yellow]%}$LEFT_PROMPT_PREFIX$LEFT_PROMPT_USER$LEFT_PROMPT_SUFIX%{$reset_color%}"
    else
      export left_prompt="$LEFT_PROMPT_PREFIX$LEFT_PROMPT_USER$LEFT_PROMPT_SUFIX"
    fi
  fi
}

precmd_functions+=(_left_prompt)
