#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz zpm

typeset -gA is=(
  linux 1
  macos 0
  ssh 0
)

typeset -ga _test_loaded=()
@zpm-load-plugins() {
  _test_loaded+=("$@")
}

# Positive if condition
_test_loaded=()
zpm if linux load my/linux-plugin
assert_eq '1' "${#_test_loaded}" 'zpm if true executes load'
assert_eq 'my/linux-plugin' "${_test_loaded[1]}" 'loaded correct plugin'

# False if condition
_test_loaded=()
zpm if macos load my/macos-plugin
assert_eq '0' "${#_test_loaded}" 'zpm if false skips load'

# if-not true condition (is[ssh]=0 -> if-not ssh is TRUE)
_test_loaded=()
zpm if-not ssh load my/non-ssh-plugin
assert_eq '1' "${#_test_loaded}" 'zpm if-not true executes load'
assert_eq 'my/non-ssh-plugin' "${_test_loaded[1]}" 'loaded correct plugin'

# Chained conditions: if linux if-not ssh load ...
_test_loaded=()
zpm if linux if-not ssh load my/chained-plugin
assert_eq '1' "${#_test_loaded}" 'chained if/if-not executes load'
assert_eq 'my/chained-plugin' "${_test_loaded[1]}" 'loaded correct plugin from chain'
