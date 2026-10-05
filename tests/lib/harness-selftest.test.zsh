#!/usr/bin/env zsh
# Verifies the harness itself: asserts that pass and fail are counted.
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"

assert_eq 'x' 'x' 'assert_eq matches equal strings'
assert_match '^foo' 'foobar' 'assert_match matches prefix'
assert_fail false 'assert_fail accepts a failing command'

# Negative control: prove failures are actually counted.
local before=$_T_FAIL
assert_eq 'a' 'b' '(intentional) unequal strings must fail'
if (( _T_FAIL == before + 1 )); then
  _T_FAIL=$before          # absorb the intentional failure
  (( _T_PASS++ ))          # and credit the meta-assertion
else
  print -u2 'HARNESS BROKEN: failure not counted'
fi

# A script with a failing assertion must exit non-zero (zsh ignores TRAPEXIT's
# return value for scripts, unlike for `zsh -c`), otherwise CI is always green.
() {
  local harness="$1" script="$(mktemp)"
  print -r -- "source '${harness}'; assert_eq a b 'child failure'" >| "$script"
  zsh -f "$script" 2>/dev/null
  assert_eq '1' "$?" 'failing test script exits with status 1'
  print -r -- "source '${harness}'; assert_eq a a 'child success'" >| "$script"
  zsh -f "$script" 2>/dev/null
  assert_eq '0' "$?" 'passing test script exits with status 0'
  rm -f "$script"
} "${0:A:h}/harness.zsh"
