#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-file-path

local fx="${0:h:h}/fixtures/filepath"

# Workarounds (resolve by name, no file check on the special path string)
assert_eq "${fx}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$(@zpm-get-plugin-file-path 'zsh-users/zsh-syntax-highlighting' "${fx}/zsh-syntax-highlighting" 'zsh-syntax-highlighting')" \
  'zsh-syntax-highlighting workaround'
assert_eq "${fx}/anything/zsh-history-substring-search.zsh" \
  "$(@zpm-get-plugin-file-path 'zsh-users/zsh-history-substring-search' "${fx}/anything" 'zsh-history-substring-search')" \
  'zsh-history-substring-search workaround'

# <basename>.zsh
assert_eq "${fx}/by-name/foo.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-name" 'foo')" 'resolves <basename>.zsh'

# <basename>.plugin.zsh
assert_eq "${fx}/by-plugin/foo.plugin.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-plugin" 'foo')" 'resolves <basename>.plugin.zsh'

# init.zsh fallback
assert_eq "${fx}/by-init/init.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-init" 'foo')" 'falls back to init.zsh'

# zsh-<basename>.zsh
assert_eq "${fx}/by-zsh-name/zsh-foo.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-zsh-name" 'foo')" 'resolves zsh-<basename>.zsh'

# zsh-<basename>.plugin.zsh
assert_eq "${fx}/by-zsh-plugin/zsh-foo.plugin.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-zsh-plugin" 'foo')" 'resolves zsh-<basename>.plugin.zsh'

# <basename>.zsh-theme
assert_eq "${fx}/by-theme/foo.zsh-theme" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/by-theme" 'foo')" 'resolves <basename>.zsh-theme'

# ,source: explicit tag
assert_eq "${fx}/by-name/foo.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo,source:foo.zsh' "${fx}/by-name" 'foo')" 'honors ,source: tag'

# ,source: pointing at missing file fails
assert_fail @zpm-get-plugin-file-path 'u/foo,source:missing.zsh' "${fx}/by-name" 'foo' \
  'missing ,source: target fails'

# Nothing resolvable fails
assert_fail @zpm-get-plugin-file-path 'u/foo' "${fx}/empty" 'nomatch' \
  'no candidate file fails'

# --- GAP 1: precedence with multiple candidates present at once ---
# precedence-a has foo.zsh + foo.plugin.zsh + init.zsh; foo.zsh must win
assert_eq "${fx}/precedence-a/foo.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/precedence-a" 'foo')" \
  'foo.zsh wins over foo.plugin.zsh and init.zsh'

# precedence-b has zsh-foo.zsh + foo.plugin.zsh (no foo.zsh); zsh-foo.zsh must win
assert_eq "${fx}/precedence-b/zsh-foo.zsh" \
  "$(@zpm-get-plugin-file-path 'u/foo' "${fx}/precedence-b" 'foo')" \
  'zsh-foo.zsh wins over foo.plugin.zsh'
