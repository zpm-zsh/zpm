#!/usr/bin/env zsh
if [[ "$OSTYPE" == "linux-android"* ]]; then
    termux-fix-shebang $(echo $_ZPM_DIR/plugins/*/bin/*)
    termux-fix-shebang $(echo $_ZPM_PLUGIN_DIR/*/bin/*)
fi
