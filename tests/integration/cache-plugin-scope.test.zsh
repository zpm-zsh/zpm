#!/usr/bin/env zsh
# A plugin loaded from the cache must not leak its shell options or its top-level
# declarations into the user's interactive shell. The cold path gets this for free
# because @zpm-source is a function; the cache has to provide the same scope.
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
_ZPM_DIR="${_ZPM_DIR:A}"

sandbox="$(mktemp -d)"
{
  export ZSH_TMP_DIR="${sandbox}/tmp"
  export ZSH_DATA_HOME="${sandbox}/data"
  export ZSH_CACHE_HOME="${sandbox}/cache"
  export _ZPM_PLUGINS_DIR="${ZSH_DATA_HOME}/plugins"
  export _ZPM_CACHE="${ZSH_TMP_DIR}/zpm-cache.zsh"
  export _ZPM_CACHE_ASYNC="${ZSH_TMP_DIR}/zpm-cache-async.zsh"
  export _ZPM_COMPDUMP="${ZSH_CACHE_HOME}/zcompdump"
  mkdir -p "${ZSH_TMP_DIR}/functions" "${ZSH_TMP_DIR}/bin" "${_ZPM_PLUGINS_DIR}" "${ZSH_CACHE_HOME}"

  fpath=("${_ZPM_DIR}/functions" $fpath)
  autoload -Uz compinit
  source "${_ZPM_DIR}/lib/init.zsh"

  _ZPM_autoload=()
  _ZPM_plugins_for_source=()
  _ZPM_plugins_for_async_source=()
  _ZPM_file_for_source=()
  _ZPM_file_for_async_source=()

  declare -Ag _ZPM_plugins_full=( '@zpm' '@zpm' )
  declare -g _zpm_parallel_format _zpm_parallel_launcher _zpm_parallel_item

  cp -r "${_ZPM_DIR}/tests/fixtures/scoped" "${_ZPM_PLUGINS_DIR}/@dir---scoped"

  @zpm-load-plugins '@dir/scoped'
  assert_eq '1' "${ZPM_SCOPED_LOADED}" 'cold start: plugin body executed'

  is='test'
  @zpm-background-initialization

  # A fresh shell whose only input is the cache, reporting what the plugin left behind.
  local runner="${sandbox}/warm.zsh"
  cat > "${runner}" <<RUNNER
fpath=("${_ZPM_DIR}/functions" \$fpath)
autoload -Uz compinit
is='test'
setopt noextendedglob
source "\$1"
print -r -- "\${options[extendedglob]}"
print -r -- "\${scoped_local-UNSET}"
print -r -- "\${ZERO-UNSET}"
print -r -- "\${ZPM_SCOPED_LOADED}"
RUNNER

  local -a warm
  warm=( "${(@f)$(ZSH_TMP_DIR="${ZSH_TMP_DIR}" _ZPM_COMPDUMP="${_ZPM_COMPDUMP}" \
    zsh -f "${runner}" "${_ZPM_CACHE}" 2>/dev/null)}" )

  assert_eq '1' "${warm[4]}" 'warm start: plugin body executed'
  assert_eq 'off' "${warm[1]}" 'warm start: plugin setopt does not leak into the shell'
  assert_eq 'UNSET' "${warm[2]}" 'warm start: plugin top-level local does not leak into the shell'
  assert_eq 'UNSET' "${warm[3]}" 'warm start: ZERO does not outlive the plugin'
} always {
  _ZPM_plugins_for_source=()
  _ZPM_plugins_for_async_source=()
  _ZPM_file_for_source=()
  _ZPM_file_for_async_source=()
  [[ -n "${sandbox}" ]] && rm -rf "${sandbox}"
}
