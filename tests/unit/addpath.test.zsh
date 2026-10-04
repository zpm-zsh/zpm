#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-addfpath @zpm-addpath

() {
  local tmp="$(mktemp -d)"
  local ZSH_TMP_DIR="${tmp}/cache"
  mkdir -p "${ZSH_TMP_DIR}/functions" "${ZSH_TMP_DIR}/bin" "${tmp}/src/functions" "${tmp}/src/bin"

  # Loading init.zsh must not probe cp: that runs on every warm shell start
  unset _ZPM_CP_FLAGS
  source "${_ZPM_DIR}/lib/init.zsh"
  assert_eq '0' "${+_ZPM_CP_FLAGS}" 'init.zsh does not probe cp'

  print -r -- 'new' > "${tmp}/src/functions/myfn"
  print -r -- 'other' > "${tmp}/other"
  ln -s "${tmp}/other" "${ZSH_TMP_DIR}/functions/myfn"
  @zpm-addfpath "${tmp}/src/functions"
  assert_eq '0' "$?" '@zpm-addfpath succeeds with the system cp'
  assert_eq '1' "${+_ZPM_CP_FLAGS}" 'cp flags are probed on first copy'
  assert_eq 'new' "$(<${ZSH_TMP_DIR}/functions/myfn)" '@zpm-addfpath replaces stale destination'
  assert_eq 'other' "$(<${tmp}/other)" '@zpm-addfpath does not write through destination symlink'

  print -r -- 'bin' > "${tmp}/src/bin/mybin"
  @zpm-addpath "${tmp}/src/bin"
  assert_eq '0' "$?" '@zpm-addpath succeeds with the system cp'
  assert_eq 'bin' "$(<${ZSH_TMP_DIR}/bin/mybin)" '@zpm-addpath copies files'

  rm -rf "$tmp"
}
