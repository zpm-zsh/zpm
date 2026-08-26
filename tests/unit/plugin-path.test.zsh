#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
export _ZPM_PLUGINS_DIR="/custom/zpm/plugins"
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-path

assert_eq "${_ZPM_DIR}" "$(@zpm-get-plugin-path '@zpm')" '@zpm resolves to _ZPM_DIR'
assert_eq "/custom/zpm/plugins/user---repo" "$(@zpm-get-plugin-path 'user/repo')" 'user/repo resolves to plugins/user---repo'
assert_eq "/custom/zpm/plugins/@omz---git" "$(@zpm-get-plugin-path '@omz/git')" '@omz/git resolves to plugins/@omz---git'
assert_eq "/custom/zpm/plugins/@dir---local-plugin" "$(@zpm-get-plugin-path '@dir/local-plugin')" '@dir/local-plugin resolves to plugins/@dir---local-plugin'
