#!/usr/bin/env zsh
typeset -gi _T_PASS=0 _T_FAIL=0

assert_eq() {
  local expected="$1" actual="$2" msg="$3"
  if [[ "$expected" == "$actual" ]]; then
    (( _T_PASS++ ))
  else
    (( _T_FAIL++ ))
    print -u2 "FAIL: ${msg}"
    print -u2 "  expected: '${expected}'"
    print -u2 "  actual:   '${actual}'"
  fi
}

assert_match() {
  local pattern="$1" actual="$2" msg="$3"
  if [[ "$actual" =~ $pattern ]]; then
    (( _T_PASS++ ))
  else
    (( _T_FAIL++ ))
    print -u2 "FAIL: ${msg}"
    print -u2 "  pattern: '${pattern}'"
    print -u2 "  actual:  '${actual}'"
  fi
}

assert_fail() {
  local msg="${@[-1]}"
  local -a cmd=("${@[1,-2]}")
  if "${cmd[@]}" >/dev/null 2>&1; then
    (( _T_FAIL++ ))
    print -u2 "FAIL: ${msg} (command unexpectedly succeeded: ${cmd[*]})"
  else
    (( _T_PASS++ ))
  fi
}

# Prints the summary and exits 1 if any assertion failed. tests/run.zsh calls it
# explicitly: zsh < 5.7 ignores any exit status set from an EXIT trap.
harness_finish() {
  typeset -g _T_DONE=1
  print -u2 "----"
  print -u2 "PASS=${_T_PASS} FAIL=${_T_FAIL}"
  exit $(( _T_FAIL > 0 ? 1 : 0 ))
}

# Summary for a test file run on its own. The exit status it sets only takes
# effect on zsh >= 5.7 (a script ignores TRAPEXIT's return value, hence `exit`).
TRAPEXIT() {
  # zsh runs TRAPEXIT in $(...) command-substitution subshells too; only the
  # top-level shell should print the summary.
  (( ZSH_SUBSHELL || _T_DONE )) && return
  harness_finish
}
