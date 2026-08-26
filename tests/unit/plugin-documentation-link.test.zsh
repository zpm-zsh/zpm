#!/usr/bin/env zsh
(( ${+functions[assert_eq]} )) || source "${0:h:h}/lib/harness.zsh"
: ${_ZPM_DIR:="${0:h:h:h}"}
fpath=("${_ZPM_DIR}/functions" $fpath)
autoload -Uz @zpm-get-plugin-documentation-link @zpm-get-plugin-documentation-hyperlink

# Documentation link resolution
assert_eq 'https://github.com/user/repo' "$(@zpm-get-plugin-documentation-link 'user/repo' 'github' '')" 'github doc link'
assert_eq 'https://gitlab.com/user/repo' "$(@zpm-get-plugin-documentation-link '@gl/user/repo' 'gitlab' '')" 'gitlab doc link'
assert_eq 'https://bitbucket.org/user/repo' "$(@zpm-get-plugin-documentation-link '@bb/user/repo' 'bitbucket' '')" 'bitbucket doc link'
assert_eq 'https://github.com/zpm-zsh/zpm' "$(@zpm-get-plugin-documentation-link '@zpm' 'zpm' '')" 'zpm core doc link'
assert_eq 'https://github.com/ohmyzsh/ohmyzsh' "$(@zpm-get-plugin-documentation-link '@omz' 'omz-core' '')" 'omz-core doc link'
assert_eq 'https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git' "$(@zpm-get-plugin-documentation-link '@omz/git' 'omz' '')" 'omz plugin doc link'
assert_eq 'https://github.com/ohmyzsh/ohmyzsh/tree/master/lib/completion.zsh' "$(@zpm-get-plugin-documentation-link '@omz/lib/completion' 'omz-lib' '')" 'omz-lib doc link'
assert_eq 'https://github.com/ohmyzsh/ohmyzsh/tree/master/themes/robbyrussell.zsh-theme' "$(@zpm-get-plugin-documentation-link '@omz/theme/robbyrussell' 'omz-theme' '')" 'omz-theme doc link'
assert_eq 'file:///local/path' "$(@zpm-get-plugin-documentation-link '@dir/local' 'dir' '/local/path')" 'dir doc link'
assert_eq 'file:///local/file.zsh' "$(@zpm-get-plugin-documentation-link '@file/local' 'file' '/local/file.zsh')" 'file doc link'

# Hyperlink generation (OSC 8)
local hlink="$(@zpm-get-plugin-documentation-hyperlink 'user/repo' 'https://github.com/user/repo' '')"
assert_match 'https://github.com/user/repo' "$hlink" 'hyperlink embeds URL'
assert_match 'user' "$hlink" 'hyperlink embeds name'
