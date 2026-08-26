#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-autoload @zpm-add-autoload

# Test @zpm-get-plugin-autoload
assert_eq 'func1:func2' "$(@zpm-get-plugin-autoload 'user/repo,autoload:func1:func2' '')" 'parses autoload tag'
assert_eq 'default_fn:extra_fn' "$(@zpm-get-plugin-autoload 'user/repo,autoload:extra_fn' 'default_fn:')" 'appends to default autoload'
assert_eq 'default_fn' "$(@zpm-get-plugin-autoload 'user/repo' 'default_fn')" 'returns default autoload when no tag'

# Test @zpm-add-autoload
typeset -ga _ZPM_autoload=()
@zpm-add-autoload 'myfunc1:myfunc2'
assert_eq '2' "${#_ZPM_autoload}" '_ZPM_autoload has 2 entries'
assert_eq 'myfunc1' "${_ZPM_autoload[1]}" 'first autoload function registered'
assert_eq 'myfunc2' "${_ZPM_autoload[2]}" 'second autoload function registered'
