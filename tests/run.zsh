#!/usr/bin/env zsh
local here="${0:h}"
export _ZPM_DIR="${here:h}"
source "${here}/lib/harness.zsh"

local f
for f in "${here}"/**/*.test.zsh(.N); do
  source "$f"
done
