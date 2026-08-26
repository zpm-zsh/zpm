#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-bin-path

sandbox="$(mktemp -d)"
{
  local ppath="${sandbox}/fake-plugin"
  mkdir -p "${ppath}/bin" "${ppath}/custom-execs"

  # With path: tag
  assert_eq "${ppath}/custom-execs" "$(@zpm-get-plugin-bin-path 'user/repo,path:custom-execs' "${ppath}")" 'custom path: tag resolves'

  # Default with existing bin/ dir
  assert_eq "${ppath}/bin" "$(@zpm-get-plugin-bin-path 'user/repo' "${ppath}")" 'default bin/ directory resolves'

  # No bin/ dir
  local empty_ppath="${sandbox}/empty-plugin"
  mkdir -p "${empty_ppath}"
  assert_eq "" "$(@zpm-get-plugin-bin-path 'user/empty' "${empty_ppath}")" 'empty when no bin/ directory'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
