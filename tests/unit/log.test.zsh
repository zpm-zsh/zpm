#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-log

# Matching DEBUG
local out1="$(DEBUG=zpm @zpm-log zpm:init "test message")"
assert_match "test message" "$out1" "DEBUG=zpm matches zpm:init"

local out2="$(DEBUG=zpm:init @zpm-log zpm:init:fpath "fpath message")"
assert_match "fpath message" "$out2" "DEBUG=zpm:init matches zpm:init:fpath"

# Non-matching DEBUG produces no output
local out3="$(DEBUG=zpm:upgrade @zpm-log zpm:init "should not appear")"
assert_eq "" "$out3" "Non-matching DEBUG produces empty output"

local out4="$(DEBUG="" @zpm-log zpm:init "should not appear")"
assert_eq "" "$out4" "Empty DEBUG produces empty output"
