#!/usr/bin/env zsh

function ZPM-Upgrade(){
  _Plugins_Upgrade=()

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( $_ZPM_GitHub_Plugins )
    git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" checkout "$_ZPM_DIR/" </dev/null >/dev/null 2>/dev/null 
    git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" pull </dev/null >/dev/null 2>/dev/null 
    pid=$!

    if [[ $COLORS=="true" ]]; then
      echo -en "$fg[green]Updating ZPM  ${fg[yellow]}${spin[0]}"
    else
      echo -en "Updating ZPM  ${spin[0]}"
    fi

    while $( kill -0 $pid 2>/dev/null)
    do
      for i in "${spin[@]}"
      do
        echo -ne "\b$i"
        sleep 0.1
      done
    done
    echo -e "\b✓${reset_color}"

    echo "Run plugin hooks"
    for plugg ($_ZPM_Core_Plugins); do
      type _$plugg-upgrade | grep -q "shell function" && _$plugg-upgrade
    done
    find "$_ZPM_DIR" -name "*.zsh" | while read zsh_file; do
      zcompile $zsh_file
    done
  else
    _Plugins_Upgrade+=($@)
  fi

  for i ($_Plugins_Upgrade); do
    if [[ "$i" == "ZPM" ]]; then
      echo "> Updating ZPM"
      git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" checkout "$_ZPM_DIR/"
      git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" pull
      echo "Run plugin hooks"
      for plugg ($_ZPM_Core_Plugins); do
        type _$plugg-upgrade | grep -q "shell function" && _$plugg-upgrade
      done
      find "$_ZPM_DIR" -name "*.zsh" | while read zsh_file; do
        zcompile $zsh_file
      done
    else
      if [[ -d $_ZPM_PLUGIN_DIR/$i ]]; then
        echo "> Updating: $i"
        git --git-dir="$_ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$_ZPM_PLUGIN_DIR/$i/" checkout "$_ZPM_PLUGIN_DIR/$i/"
        git --git-dir="$_ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$_ZPM_PLUGIN_DIR/$i/" pull
      fi
      type _$i-upgrade | grep -q "shell function" && _$plugg-upgrade
      find "$_ZPM_PLUGIN_DIR/$i" -name "*.zsh" | while read zsh_file; do
        zcompile $zsh_file
      done
    fi
  done
}

function _ZPM-Upgrade(){
  _ZPM_Hooks=( "$_ZPM_GitHub_Plugins" )
  for plugg ($_ZPM_Core_Plugins); do
    if type _$plugg-upgrade | grep "shell function" >/dev/null; then
      _ZPM_Hooks+=($plugg)
    fi
  done
  _arguments "*: :($(echo ZPM; echo $_ZPM_Hooks))"
}

compdef _ZPM-Upgrade ZPM-Upgrade