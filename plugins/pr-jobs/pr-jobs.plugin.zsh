PR_JOBS_PREFIX="${PR_JOBS_PREFIX=" "}"
PR_JOBS_SUFFIX="${PR_JOBS_SUFFIX=""}"
PR_JOBS_SYMBOL="${PR_JOBS_SYMBOL=""}"

_pr_jobs() {
  
  
  local jobs=$( jobs -d | awk '!/pwd/' | wc -l | tr -d " ")
  
  
  if [[ $jobs -gt 0 ]] ; then
    if [[ $CLICOLOR = 1 ]]; then
      pr_jobs="$PR_JOBS_PREFIX%{$fg_bold[blue]%}$PR_JOBS_SYMBOL%{$reset_color%}$PR_JOBS_SUFFIX"
    else
      pr_jobs="$PR_JOBS_PREFIX$PR_JOBS_SYMBOL$PR_JOBS_SUFFIX"
    fi
    
  else
    pr_jobs=''
  fi
  
}


precmd_functions+=(_pr_jobs)
