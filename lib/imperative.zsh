#!/usr/bin/env zsh

function _ZPM_Post_Initialization(){
  
  echo > "$_ZPM_CACHE"
  echo > "$_ZPM_CACHE_ASYNC"
  
  echo 'export ZPFX="${HOME}/.local"' >> "$_ZPM_CACHE"
  echo "typeset -a zsh_loaded_plugins=('${(j:' ':)_ZPM_plugins_no_source}')" >> "$_ZPM_CACHE"
  echo "typeset -A _ZPM_plugins_full=('${(kvj:' ':)_ZPM_plugins_full}')" >> "$_ZPM_CACHE"
  echo '_ZPM_plugins_full[zpm]="zpm"' >> "$_ZPM_CACHE"

  echo "export PATH=\"${_ZPM_PATH}\${PATH}\"" >> "$_ZPM_CACHE"
  echo "fpath=( \$fpath '${(j:' ':)_ZPM_fpath}' )" >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'autoload -Uz compinit' >> "$_ZPM_CACHE"
  echo '_comp_files=(${HOME}/.zcompdump(Nm-20))' >> "$_ZPM_CACHE"
  echo 'if (( $#_comp_files )); then' >> "$_ZPM_CACHE"
  echo '  compinit -i -C' >> "$_ZPM_CACHE"
  echo 'else' >> "$_ZPM_CACHE"
  echo '  compinit -i' >> "$_ZPM_CACHE"
  echo 'fi' >> "$_ZPM_CACHE"
  echo 'unset _comp_files' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  for plugin in ${_ZPM_plugins_for_source}; do
    local file="$_ZPM_file_for_source["$plugin"]"
    echo "zsh_loaded_plugins+=('$plugin')" >> "$_ZPM_CACHE"
    echo "ZERO='${file%%___ZPM_inline}'" >> "$_ZPM_CACHE"
    if [[ "$file" == *"___ZPM_inline" ]]; then
      echo "# Inlined from '${file%%___ZPM_inline}'" >> "$_ZPM_CACHE"
      cat "${file%%___ZPM_inline}" >> "$_ZPM_CACHE"
    else
      echo "source '${file}'" >> "$_ZPM_CACHE"
    fi
  echo >> "$_ZPM_CACHE"
  done
  
  echo '_ZPM_post_fn () {' >> "$_ZPM_CACHE"
  
  for plugin in ${_ZPM_plugins_for_async_source}; do
    local file="$_ZPM_file_for_async_source["$plugin"]"
    echo "zsh_loaded_plugins+=('$plugin')" >> "$_ZPM_CACHE_ASYNC"
    echo "ZERO='${file%%___ZPM_inline}'" >> "$_ZPM_CACHE_ASYNC"
    if [[ "$file" == *"___ZPM_inline" ]]; then
      echo "# Inlined from '${file%%___ZPM_inline}'" >> "$_ZPM_CACHE_ASYNC"
      cat "${file%%___ZPM_inline}" >> "$_ZPM_CACHE_ASYNC"
    else
      echo "source '$file'" >> "$_ZPM_CACHE_ASYNC"
    fi
  echo >> "$_ZPM_CACHE_ASYNC"
  done
  
  cat "${_ZPM_DIR}/lib/functions.zsh" >> "$_ZPM_CACHE_ASYNC"
  cat "${_ZPM_DIR}/lib/completion.zsh" >> "$_ZPM_CACHE_ASYNC"
  
  echo >> "$_ZPM_CACHE"

  echo "source '$_ZPM_CACHE_ASYNC'" >> "$_ZPM_CACHE"
  
  echo 'TMOUT=5' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'add-zsh-hook -d background _ZPM_post_fn' >> "$_ZPM_CACHE"
  echo '}' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'typeset -aU path' >> "$_ZPM_CACHE"
  echo 'export PATH' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'TMOUT=1' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'add-zsh-hook background _ZPM_post_fn' >> "$_ZPM_CACHE"
  echo >> "$_ZPM_CACHE"
  
  echo 'zpm () {}' >> "$_ZPM_CACHE"


  zcompile "$_ZPM_CACHE" 2>/dev/null
  zcompile "${HOME}/.zshrc" 2>/dev/null
  zcompile "${_ZPM_DIR}/zpm.zsh" 2>/dev/null
  zcompile "${_ZPM_DIR}/lib/functions.zsh" 2>/dev/null

  source "${_ZPM_DIR}/lib/completion.zsh"

  compinit
  add-zsh-hook -d precmd _ZPM_Post_Initialization
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ZPM_Post_Initialization

autoload -Uz compinit
_comp_files=(${HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files


zpm zpm-zsh/helpers,inline zpm-zsh/colors,inline zpm-zsh/background,inline
