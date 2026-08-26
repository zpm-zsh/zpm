#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-type

# Special names
assert_eq 'zpm'      "$(@zpm-get-plugin-type '@zpm')"        '@zpm special'
assert_eq 'omz-core' "$(@zpm-get-plugin-type '@omz')"        '@omz special'

# user/repo shorthand → github
assert_eq 'github'   "$(@zpm-get-plugin-type 'user/repo')"   'bare user/repo is github'

# typed prefixes
assert_eq 'github'    "$(@zpm-get-plugin-type '@gh/u/r')"        'gh alias'
assert_eq 'github'    "$(@zpm-get-plugin-type '@github/u/r')"    'github'
assert_eq 'gitlab'    "$(@zpm-get-plugin-type '@gl/u/r')"        'gl alias'
assert_eq 'gitlab'    "$(@zpm-get-plugin-type '@gitlab/u/r')"    'gitlab'
assert_eq 'bitbucket' "$(@zpm-get-plugin-type '@bb/u/r')"        'bb alias'
assert_eq 'bitbucket' "$(@zpm-get-plugin-type '@bitbucket/u/r')" 'bitbucket'
assert_eq 'git'       "$(@zpm-get-plugin-type '@git/u/r')"       'git'
assert_eq 'file'      "$(@zpm-get-plugin-type '@file/x')"        'file'
assert_eq 'dir'       "$(@zpm-get-plugin-type '@dir/x')"         'dir'
assert_eq 'dir'       "$(@zpm-get-plugin-type '@link/x')"        'link maps to dir'
assert_eq 'omz-theme' "$(@zpm-get-plugin-type '@omz/theme/x')"   'omz/theme'
assert_eq 'omz-lib'   "$(@zpm-get-plugin-type '@omz/lib/x')"     'omz/lib'
assert_eq 'omz'       "$(@zpm-get-plugin-type '@omz/x')"         'omz plugin'
assert_eq 'remote'    "$(@zpm-get-plugin-type '@remote/x')"      'remote'
assert_eq 'gist'      "$(@zpm-get-plugin-type '@gist/x')"        'gist'
assert_eq 'exec'      "$(@zpm-get-plugin-type '@exec/x')"        'exec'
assert_eq 'empty'     "$(@zpm-get-plugin-type '@empty/x')"       'empty'
assert_eq 'omz-theme-old' "$(@zpm-get-plugin-type '@omz-theme/x')" 'omz-theme legacy'
assert_eq 'omz-lib-old'   "$(@zpm-get-plugin-type '@omz-lib/x')"   'omz-lib legacy'

# Failure edges
assert_fail @zpm-get-plugin-type '@unknown/x' 'unknown @type fails'
assert_fail @zpm-get-plugin-type 'singleword' 'bare word without slash fails'
