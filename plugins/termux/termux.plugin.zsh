#!/usr/bin/env zsh
if [[ "$OSTYPE" == "linux-android"* ]]; then
    termux-fix-shebang $(echo ~/.zpm/plugins/*/bin/*)
    termux-fix-shebang $(echo ~/.local/share/zpm/plugins/*/bin/*)
fi
