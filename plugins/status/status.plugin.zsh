#!/usr/bin/env zsh

export LAST_STATUS_TRUE=${LAST_STATUS_TRUE:-'✓'}
export LAST_STATUS_FALSE=${LAST_STATUS_FALSE:-'✗'}


_status() {
  RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        if [[ $COLORS == "true" ]]; then
            export last_status="%{$fg[yellow]%}$LAST_STATUS_TRUE%{$reset_color%}"
        else
            export last_status="$LAST_STATUS_TRUE"
        fi
    else
        if [ $RETVAL -ne 0 ]; then
        if [[ $COLORS == "true" ]]; then
            export last_status="%{$fg[red]%}$LAST_STATUS_FALSE%{$reset_color%}"
        else
            export last_status="$LAST_STATUS_FALSE"
        fi
      fi
    fi
}

precmd_functions+=(_status)
