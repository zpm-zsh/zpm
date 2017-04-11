#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()
_ZPM_GitHub_Plugins+=()
_ZPM_Core_Plugins+=()


function _ZPM_Initialize_Plugin(){
  _ZPM_Plugins+=(${plugin})
  _ZPM_Core_Plugins+=(${plugin})
  local plugin=${1}

  if [[ ! "${plugin}" == */* ]]; then

    if [[ -d "${_ZPM_DIR}/plugins/${plugin}" ]]; then
      
      [[ ":$FPATH:" != *":${_ZPM_DIR}/plugins/${plugin}:"* ]] && FPATH="$FPATH:${_ZPM_DIR}/plugins/${plugin}"

      if [[ -d "${_ZPM_DIR}/plugins/${plugin}/bin" ]]; then
        [[ ":$PATH:" != *":${_ZPM_DIR}/plugins/${plugin}/bin:"* ]] && PATH="$PATH:${_ZPM_DIR}/plugins/${plugin}/bin"
      fi

      if [[ -d "${_ZPM_DIR}/plugins/${plugin}/man" ]]; then
        [[ ":$MANPATH:" != *":${_ZPM_DIR}/plugins/${plugin}/man:"* ]] && MANPATH="$MANPATH:${_ZPM_DIR}/plugins/${plugin}/man"
      fi

      if [[ -f "${_ZPM_DIR}/plugins/${plugin}/${plugin}.plugin.zsh" ]]; then
        source "${_ZPM_DIR}/plugins/${plugin}/${plugin}.plugin.zsh"
      fi

    elif [[ -d "${HOME}/.oh-my-zsh/plugins/${plugin}" ]]; then

      [[ ":$FPATH:" != *":${HOME}/.oh-my-zsh/plugins/${plugin}:"* ]] && FPATH="$FPATH:${HOME}/.oh-my-zsh/plugins/${plugin}"

      if [[ -f "${HOME}/.oh-my-zsh/plugins/${plugin}/${plugin}.plugin.zsh" ]]; then
        source "${HOME}/.oh-my-zsh/plugins/${plugin}/${plugin}.plugin.zsh"
      fi

    fi

    return

  fi

  local plugin_name="${plugin}"
  plugin_name=${plugin_name##*\/}
  if [[ "${plugin_name}" == zsh-*  ]]; then
    plugin_name=${plugin_name:4}
  fi
  if [[ "${plugin_name}" == *.zsh  ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-4}
  fi
  if [[ "${plugin_name}" == *.plugin  ]]; then
    plugin_name=${plugin_name:0:${#plugin_name}-7}
  fi

  _Install_from_GitHub ${plugin_name} ${plugin}

  [[ ":$FPATH:" != *":${_ZPM_PLUGIN_DIR}/${plugin_name}:"* ]] && FPATH="$FPATH:${_ZPM_PLUGIN_DIR}/${plugin_name}"

  if [[ -d ${_ZPM_PLUGIN_DIR}/${plugin_name}/bin ]]; then
    PATH="$PATH:${_ZPM_PLUGIN_DIR}/${plugin_name}/bin"
  fi

  if [[ -d ${_ZPM_PLUGIN_DIR}/${plugin_name}/man ]]; then
    [[ ":$MANPATH:" != *":${_ZPM_PLUGIN_DIR}/${plugin_name}/man:"* ]] && MANPATH="$MANPATH:${_ZPM_PLUGIN_DIR}/${plugin_name}/man"
  fi

  if [[ -f ${_ZPM_PLUGIN_DIR}/${plugin_name}/${plugin_name}.plugin.zsh ]]; then
    source ${_ZPM_PLUGIN_DIR}/${plugin_name}/${plugin_name}.plugin.zsh
  elif [[ -f ${_ZPM_PLUGIN_DIR}/${plugin_name}/zsh-${plugin_name}.plugin.zsh ]]; then
    source ${_ZPM_PLUGIN_DIR}/${plugin_name}/zsh-${plugin_name}.plugin.zsh
  elif [[ -f ${_ZPM_PLUGIN_DIR}/${plugin_name}/${plugin_name}.zsh ]]; then
    source ${_ZPM_PLUGIN_DIR}/${plugin_name}/${plugin_name}.zsh
  fi

  _ZPM_Plugins+=(${plugin_name})
  _ZPM_GitHub_Plugins+=(${plugin_name})

}

function _ZPM_Init(){
  precmd_functions=(${precmd_functions#_ZPM_Init})
}
precmd_functions+=(_ZPM_Init) 

