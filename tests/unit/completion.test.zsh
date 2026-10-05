#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)

# compsys only runs inside a completion widget: stand in for the functions _zpm
# calls and record the candidates it offers.
() {
  local sandbox="$(mktemp -d)"
  local _ZPM_PLUGINS_DIR="${sandbox}/plugins"
  mkdir -p "${_ZPM_PLUGINS_DIR}"/{u---a,u---b,u---c}
  local -A _ZPM_plugins_full=( @zpm @zpm u/c u/c )
  local -a words offered
  local CURRENT

  _arguments() { return 1 }
  _describe() { offered=( "${(@P)4}" ) }
  _files() { offered=( FILES ) }
  (( ${+functions[is-callable]} )) || is-callable() { (( ${+functions[$1]} || ${+commands[$1]} )) }

  complete() {
    local LC_ALL=C
    words=( "$@" ); CURRENT=$#words; offered=()
    autoload -Uz +X _zpm
    _zpm
    print -r -- "${(j: :)${(o)offered[@]%%:*}}"
  }

  assert_eq 'c clean if if-not info link list load ls readme u upgrade' "$(complete '')" 'first word: subcommands'
  assert_eq 'u/a u/b' "$(complete load '')" 'load: installed, not loaded plugins'
  assert_eq 'u/b' "$(complete load u/a '')" 'load: second argument, minus the ones already typed'
  assert_eq '@zpm u/c' "$(complete upgrade '')" 'upgrade: loaded plugins'
  assert_eq 'u/c' "$(complete upgrade @zpm '')" 'upgrade: second argument, minus the ones already typed'
  assert_eq 'u/c' "$(complete info @zpm '')" 'info: second argument'
  assert_eq 'FILES' "$(complete link ./a '')" 'link: files for every argument'
  assert_eq '' "$(complete clean '')" 'clean: no arguments'
  assert_eq 'android bsd iterm linux macos msys ssh termux vscode vte' "$(complete if '')" 'if: conditions'
  assert_eq 'if if-not load' "$(complete if ssh '')" 'if <cond>: next command'
  assert_eq 'u/b' "$(complete if ssh load u/a '')" 'if <cond> load: further arguments'
  assert_eq 'u/a u/b' "$(complete if ssh if-not vte load '')" 'chained conditions'

  rm -rf "$sandbox"
}
