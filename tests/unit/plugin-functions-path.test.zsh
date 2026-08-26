#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-functions-path

local fx="${0:h:h}/fixtures/fpath"

# sindresorhus/pure workaround → plugin path itself (absolute)
assert_eq "${fx:a}/custom" "$(@zpm-get-plugin-functions-path 'sindresorhus/pure' "${fx}/custom")" \
  'pure workaround returns plugin path'

# functions/ subdir preferred
assert_eq "${fx:a}/has-functions/functions" \
  "$(@zpm-get-plugin-functions-path 'u/x' "${fx}/has-functions")" 'prefers functions/ dir'

# _* files → plugin dir as fpath
assert_eq "${fx:a}/has-underscore" \
  "$(@zpm-get-plugin-functions-path 'u/x' "${fx}/has-underscore")" 'underscore files use plugin dir'

# ,fpath: tag
assert_eq "${fx:a}/custom/lib" \
  "$(@zpm-get-plugin-functions-path 'u/x,fpath:lib' "${fx}/custom")" 'honors ,fpath: tag'
