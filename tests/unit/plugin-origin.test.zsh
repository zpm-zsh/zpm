#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-origin

# Default mirrors (args: spec name basename type origin_type)
assert_eq 'https://github.com/user/repo' \
  "$(@zpm-get-plugin-origin 'user/repo' 'user/repo' 'repo' 'github' 'git')" 'github default url'
assert_eq 'https://gitlab.com/user/repo' \
  "$(@zpm-get-plugin-origin '@gl/user/repo' '@gl/user/repo' 'repo' 'gitlab' 'git')" 'gitlab default url'
assert_eq 'https://bitbucket.org/user/repo' \
  "$(@zpm-get-plugin-origin '@bb/user/repo' '@bb/user/repo' 'repo' 'bitbucket' 'git')" 'bitbucket default url'
assert_eq 'https://github.com/ohmyzsh/ohmyzsh' \
  "$(@zpm-get-plugin-origin '@omz' '@omz' 'omz' 'omz-core' 'git')" 'omz-core url'
assert_eq 'https://gist.githubusercontent.com/user/abc/raw' \
  "$(@zpm-get-plugin-origin '@gist/user/abc' '@gist/user/abc' 'abc' 'gist' 'remote')" 'gist raw url'

# origin: override wins
assert_eq 'git@example.com:me/x.git' \
  "$(@zpm-get-plugin-origin 'user/repo,origin:git@example.com:me/x.git' 'user/repo' 'repo' 'github' 'git')" \
  'origin override'

# Mirror env override
assert_eq 'https://ghmirror.local/user/repo' \
  "$(GITHUB_MIRROR='https://ghmirror.local' @zpm-get-plugin-origin 'user/repo' 'user/repo' 'repo' 'github' 'git')" \
  'GITHUB_MIRROR override'
assert_eq 'https://glmirror.local/user/repo' \
  "$(GITLAB_MIRROR='https://glmirror.local' @zpm-get-plugin-origin '@gl/user/repo' '@gl/user/repo' 'repo' 'gitlab' 'git')" \
  'GITLAB_MIRROR override'
assert_eq 'https://bbmirror.local/user/repo' \
  "$(BITBUCKET_MIRROR='https://bbmirror.local' @zpm-get-plugin-origin '@bb/user/repo' '@bb/user/repo' 'repo' 'bitbucket' 'git')" \
  'BITBUCKET_MIRROR override'

# Unknown type fails
assert_fail @zpm-get-plugin-origin 'x' 'x' 'x' 'bogus' 'git' 'unknown type fails'
