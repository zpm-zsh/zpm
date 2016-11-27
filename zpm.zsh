#!/usr/bin/env zsh

if [[ -z "$COLORS" ]]; then
  COLORS=true
fi

if [[ -z "$MANPATH" ]]; then
  if hash manpath 2>/dev/null; then
    MANPATH="$(manpath)"
  fi
fi

if [[ -z "$PERIOD" ]]; then
  PERIOD=10
fi

if [[ "$COLORS" == "true" ]]; then
  autoload -U colors && colors
  TERM="xterm-256color"
fi

if [[ -z "$EMOJI" ]]; then
  EMOJI="true"
fi

if [[ -z "$SHELL" ]]; then
  SHELL="$(which zsh)"
fi

if [[ -z "$ZPM_DIR" ]]; then
  _ZPM_DIR="${${(%):-%x}:a:h}"
else
  _ZPM_DIR="$ZPM_DIR"
  unset ZPM_DIR
fi

if [[ -z "$ZPM_PLUGIN_DIR" ]]; then
  _ZPM_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zpm"
else
  _ZPM_PLUGIN_DIR="$ZPM_PLUGIN_DIR"
  unset ZPM_PLUGIN_DIR
fi

ZSH_COMPDUMP="$HOME/.zcompdump"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=9999
SAVEHIST=9999
WORDCHARS="*?_-~=&;!#$%^()[]{}<>:."
PAGER=less
EDITOR=vim
VISUAL=vim
LISTMAX=9999


# Some modules
setopt prompt_subst
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "~/.cache/zsh"
autoload -U compinit && compinit
zmodload zsh/terminfo

mkdir -p "$_ZPM_PLUGIN_DIR"

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()
_ZPM_GitHub_Plugins+=()
_ZPM_Core_Plugins+=()


function _ZPM_Initialize_Plugin(){
  local plugin=$1
  if [[ ! "$plugin" == */* ]]; then
    fpath=( $fpath "$_ZPM_DIR/plugins/$plugin" )

    if [[ -d "$_ZPM_DIR/plugins/$plugin/bin" ]]; then
      path=( $path "$_ZPM_DIR/plugins/$plugin/bin" )
    fi

    if [[ -d "$_ZPM_DIR/plugins/$plugin/man" ]]; then
      manpath=( $manpath "$_ZPM_DIR/plugins/$plugin/man" )
    fi

    if [[ -f "$_ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh" ]]; then
      source "$_ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh"
    fi

    _ZPM_Plugins+=( $plugin )
    _ZPM_Core_Plugins+=( $plugin )
    return
  fi

  local plugin_name="$plugin"
  plugin_name=${plugin_name##*\/}
  if [[ "$plugin_name" == zsh-*  ]]; then
    plugin_name=${plugin_name:4}
  fi
  if [[ "$plugin_name" == *.zsh  ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-4}
  fi
  if [[ "$plugin_name" == *.plugin  ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-7}
  fi

  if [[ ! -d "$_ZPM_PLUGIN_DIR/$plugin_name" ]]; then
    echo "Installing $plugin from GitHub"
    git clone --recursive "https://github.com/"$plugin".git" "$_ZPM_PLUGIN_DIR/$plugin_name"
    find "$_ZPM_PLUGIN_DIR/$plugin_name" -name "*.zsh" | while read zsh_file; do
      zcompile "$zsh_file"
    done
  fi

  fpath=( $_ZPM_PLUGIN_DIR/$plugin_name $fpath )

  if [[ -d $_ZPM_PLUGIN_DIR/$plugin_name/bin ]]; then
    path=( $path $_ZPM_PLUGIN_DIR/$plugin_name/bin )
  fi

  if [[ -d $_ZPM_PLUGIN_DIR/$plugin_name/man ]]; then
    manpath=( $manpath $_ZPM_PLUGIN_DIR/$plugin_name/man )
  fi

  if [[ -f $_ZPM_PLUGIN_DIR/$plugin_name/$plugin_name.plugin.zsh ]]; then
    source $_ZPM_PLUGIN_DIR/$plugin_name/$plugin_name.plugin.zsh
  elif [[ -f $_ZPM_PLUGIN_DIR/$plugin_name/zsh-$plugin_name.plugin.zsh ]]; then
    source $_ZPM_PLUGIN_DIR/$plugin_name/zsh-$plugin_name.plugin.zsh
  fi
  _ZPM_Plugins+=( $plugin_name )
  _ZPM_GitHub_Plugins+=( $plugin_name )

}


function _ZPM_Init(){
  compinit
  precmd_functions=(${precmd_functions#_ZPM_Init})
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

function Plug(){
  for plugin ($@); do
    _ZPM_Initialize_Plugin $plugin
  done
}


# ----------
# ZPM Upgrade Hooks
# ----------

function ZPM-Upgrade(){
  _Plugins_Upgrade=()

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( $_ZPM_GitHub_Plugins )
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

compdef _ZPM-Upgrade ZPM-Upgrade

precmd_functions+=(_ZPM_Init)

{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
