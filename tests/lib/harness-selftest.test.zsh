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
