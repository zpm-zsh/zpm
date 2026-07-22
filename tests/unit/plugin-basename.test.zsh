#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-basename

assert_eq 'repo' "$(@zpm-get-plugin-basename 'user/repo')" 'last path segment'
assert_eq 'repo' "$(@zpm-get-plugin-basename '@gl/user/repo')" 'last segment with type prefix'
assert_eq 'name' "$(@zpm-get-plugin-basename 'name')" 'no slash returns input'
