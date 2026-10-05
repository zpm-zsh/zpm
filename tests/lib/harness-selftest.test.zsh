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

# A run with a failing assertion must exit non-zero, otherwise CI is always green.
() {
  local harness="$1" script="$(mktemp)"

  # harness_finish, as called by tests/run.zsh: works on every zsh version
  print -r -- "source '${harness}'; assert_eq a b 'child failure'; harness_finish" >| "$script"
  zsh -f "$script" 2>/dev/null
  assert_eq '1' "$?" 'harness_finish exits with status 1 on failure'
  print -r -- "source '${harness}'; assert_eq a a 'child success'; harness_finish" >| "$script"
  zsh -f "$script" 2>/dev/null
  assert_eq '0' "$?" 'harness_finish exits with status 0 on success'

  # A test file run on its own relies on TRAPEXIT, whose exit status zsh < 5.7 ignores
  autoload -Uz is-at-least
  if is-at-least 5.7; then
    print -r -- "source '${harness}'; assert_eq a b 'child failure'" >| "$script"
    zsh -f "$script" 2>/dev/null
    assert_eq '1' "$?" 'failing test script exits with status 1'
    print -r -- "source '${harness}'; assert_eq a a 'child success'" >| "$script"
    zsh -f "$script" 2>/dev/null
    assert_eq '0' "$?" 'passing test script exits with status 0'
  fi
  rm -f "$script"
} "${0:A:h}/harness.zsh"
