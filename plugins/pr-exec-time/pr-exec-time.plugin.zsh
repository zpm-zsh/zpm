PR_EXEC_TIME_PREFIX="${PR_EXEC_TIME_PREFIX=" "}"
PR_EXEC_TIME_SUFFIX="${PR_EXEC_TIME_SUFFIX=""}"
PR_EXEC_TIME_ELAPSED="${PR_EXEC_TIME_ELAPSED=2}"


_pr_exec_time() {
  
  if [ $_pr_exec_time_timer ]; then
    local pr_time_spend=$(($SECONDS - $_pr_exec_time_timer))
    if [[ $pr_time_spend -ge $PR_EXEC_TIME_ELAPSED ]]; then
      
      if [[ $CLICOLOR = 1 ]]; then
        pr_exec_time="$PR_EXEC_TIME_PREFIX%{$fg_bold[yellow]%}$pr_time_spend"s"%{$reset_color%}$PR_EXEC_TIME_SUFFIX"
      else
        pr_exec_time="$PR_EXEC_TIME_PREFIX$pr_time_spend"s"$PR_EXEC_TIME_SUFFIX"
      fi
    else
      pr_exec_time=''
    fi
    unset _pr_exec_time_timer
  fi
  
}

function _pr_exec_time_preexec() {
  _pr_exec_time_timer=${_pr_exec_time_timer:-$SECONDS}
}

preexec_functions+=(_pr_exec_time_preexec)
precmd_functions+=(_pr_exec_time)
