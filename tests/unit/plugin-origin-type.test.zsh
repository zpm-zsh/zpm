#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-origin-type

assert_eq 'git' "$(@zpm-get-plugin-origin-type '@zpm')"  '@zpm origin git'
assert_eq 'git' "$(@zpm-get-plugin-origin-type '@omz')"  '@omz origin git'
assert_eq 'git' "$(@zpm-get-plugin-origin-type 'user/repo')" 'bare user/repo origin git'

assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@gh/u/r')"      'gh git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@github/u/r')"  'github git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@gl/u/r')"      'gl git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@gitlab/u/r')"  'gitlab git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@bb/u/r')"      'bb git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@bitbucket/u/r')" 'bitbucket git'
assert_eq 'git'       "$(@zpm-get-plugin-origin-type '@git/u/r')"     'git git'
assert_eq 'file-link' "$(@zpm-get-plugin-origin-type '@file/x')"      'file file-link'
assert_eq 'file-link' "$(@zpm-get-plugin-origin-type '@omz/theme/x')" 'omz/theme file-link'
assert_eq 'file-link' "$(@zpm-get-plugin-origin-type '@omz/lib/x')"   'omz/lib file-link'
assert_eq 'dir-link'  "$(@zpm-get-plugin-origin-type '@dir/x')"       'dir dir-link'
assert_eq 'dir-link'  "$(@zpm-get-plugin-origin-type '@link/x')"      'link dir-link'
assert_eq 'dir-link'  "$(@zpm-get-plugin-origin-type '@omz/x')"       'omz dir-link'
assert_eq 'remote'    "$(@zpm-get-plugin-origin-type '@remote/x')"    'remote'
assert_eq 'remote'    "$(@zpm-get-plugin-origin-type '@gist/x')"      'gist remote'
assert_eq 'exec'      "$(@zpm-get-plugin-origin-type '@exec/x')"      'exec'
assert_eq 'empty'     "$(@zpm-get-plugin-origin-type '@empty/x')"     'empty'

assert_fail @zpm-get-plugin-origin-type '@unknown/x' 'unknown @type fails'
assert_fail @zpm-get-plugin-origin-type 'singleword' 'bare word fails'
