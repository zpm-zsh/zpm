#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-destination-path

local ppath="/path/to/plugin"
local basename="mytool"

# Git and dir-link types return Plugin_path directly
assert_eq "${ppath}" "$(@zpm-get-plugin-destination-path 'user/repo' "${ppath}" "${basename}" 'git')" 'git origin returns plugin_path'
assert_eq "${ppath}" "$(@zpm-get-plugin-destination-path '@dir/repo' "${ppath}" "${basename}" 'dir-link')" 'dir-link origin returns plugin_path'

# Remote/file-link/exec with default destination
assert_eq "${ppath}/${basename}.zsh" "$(@zpm-get-plugin-destination-path '@remote/tool' "${ppath}" "${basename}" 'remote')" 'remote default destination is .zsh'
assert_eq "${ppath}/${basename}.zsh" "$(@zpm-get-plugin-destination-path '@exec/tool' "${ppath}" "${basename}" 'exec')" 'exec default destination is .zsh'

# destination:completion
assert_eq "${ppath}/functions/_${basename}" "$(@zpm-get-plugin-destination-path '@remote/tool,destination:completion' "${ppath}" "${basename}" 'remote')" 'destination:completion outputs to functions/_basename'
assert_eq "${ppath}/functions/_${basename}" "$(@zpm-get-plugin-destination-path '@exec/tool,destination:completion' "${ppath}" "${basename}" 'exec')" 'exec destination:completion outputs to functions/_basename'

# destination:bin
assert_eq "${ppath}/bin/${basename}" "$(@zpm-get-plugin-destination-path '@remote/tool,destination:bin' "${ppath}" "${basename}" 'remote')" 'destination:bin outputs to bin/basename'
assert_eq "${ppath}/bin/${basename}" "$(@zpm-get-plugin-destination-path '@exec/tool,destination:bin' "${ppath}" "${basename}" 'exec')" 'exec destination:bin outputs to bin/basename'
