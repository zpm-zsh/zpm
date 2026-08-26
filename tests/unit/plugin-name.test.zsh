#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-name

assert_eq 'zsh-users/zsh-syntax-highlighting' \
  "$(@zpm-get-plugin-name 'zsh-users/zsh-syntax-highlighting')" 'plain name'
assert_eq 'user/repo' "$(@zpm-get-plugin-name 'user/repo,async')" 'strips tags'
assert_eq '@gl/user/repo' "$(@zpm-get-plugin-name '@gl/user/repo,apply:source')" 'strips at first comma'
