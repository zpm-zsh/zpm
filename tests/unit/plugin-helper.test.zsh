#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}

sandbox="$(mktemp -d)"
{
  export ZSH_TMP_DIR="${sandbox}/tmp"
  export ZSH_DATA_HOME="${sandbox}/data"
  export ZSH_CACHE_HOME="${sandbox}/cache"
  export _ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
  export CLICOLOR=0
  mkdir -p "${ZSH_TMP_DIR}" "${_ZPM_PLUGINS_DIR}" "${ZSH_CACHE_HOME}"

  # Test 1: @empty/ plugin creates empty directory
  "${_ZPM_DIR}/bin/@zpm-plugin-helper" install '@empty/empty-pkg'
  assert_eq '1' "$([[ -d "${_ZPM_PLUGINS_DIR}/@empty---empty-pkg" ]] && echo 1 || echo 0)" '@empty creates directory'

  # Test 2: @file/ symlinks a single file
  local local_file="${sandbox}/my-file.zsh"
  echo "echo 'test'" > "${local_file}"
  "${_ZPM_DIR}/bin/@zpm-plugin-helper" install "@file/my-file,origin:${local_file}"
  assert_eq '1' "$([[ -L "${_ZPM_PLUGINS_DIR}/@file---my-file/my-file.zsh" ]] && echo 1 || echo 0)" '@file creates symlink'

  # Test 3: @dir/ symlinks a directory
  local local_dir="${sandbox}/my-dir-pkg"
  mkdir -p "${local_dir}"
  "${_ZPM_DIR}/bin/@zpm-plugin-helper" install "@dir/my-dir-pkg,origin:${local_dir}"
  assert_eq '1' "$([[ -L "${_ZPM_PLUGINS_DIR}/@dir---my-dir-pkg" ]] && echo 1 || echo 0)" '@dir creates directory symlink'

  # Test 4: @exec/ with destination:bin sets executable chmod +x
  "${_ZPM_DIR}/bin/@zpm-plugin-helper" install '@exec/test-bin,origin:echo "#!/bin/sh\necho hi",destination:bin'
  local bin_file="${_ZPM_PLUGINS_DIR}/@exec---test-bin/bin/test-bin"
  assert_eq '1' "$([[ -f "${bin_file}" && -x "${bin_file}" ]] && echo 1 || echo 0)" '@exec destination:bin creates executable'

  # Test 5: hook execution
  local hook_marker="${sandbox}/hook-ran"
  "${_ZPM_DIR}/bin/@zpm-plugin-helper" install "@empty/hook-pkg,hook:touch ${hook_marker}"
  assert_eq '1' "$([[ -f "${hook_marker}" ]] && echo 1 || echo 0)" 'hook command executed after install'
} always {
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
