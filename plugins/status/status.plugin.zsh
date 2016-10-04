#!/usr/bin/env zsh


LAST_STATUS_TRUE=${LAST_STATUS_TRUE:-'✓'}
LAST_STATUS_FALSE=${LAST_STATUS_FALSE:-'✗'}


_status() {
  RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        export last_status="$LAST_STATUS_TRUE"
        if [[ $COLORS == "true" ]]; then
            export last_status="%{$fg[yellow]%}$LAST_STATUS_TRUE%{$reset_color%}"
        fi
    else
        if [ $RETVAL -ne 0 ]; then
        export last_status="$LAST_STATUS_FALSE"
        if [[ $COLORS == "true" ]]; then
            export last_status="%{$fg[red]%}$LAST_STATUS_FALSE%{$reset_color%}"
        fi
      fi
    fi
}

precmd_functions+=(_status)
