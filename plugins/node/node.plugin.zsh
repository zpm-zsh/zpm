#!/usr/bin/env zsh

NODE_VERSION_PREFIX=${NODE_VERSION_PREFIX:-" "}
NODE_VERSION_SUFIX=${NODE_VERSION_SUFIX:-""}


function node-docs {
    local open_cmd
    if [[ "$OSTYPE" = darwin* ]]; then
        open_cmd='open'
    else
        open_cmd='xdg-open'
    fi

    $open_cmd "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
}

_node_version() {
    if [ -d "./node_modules" -o -d "../node_modules" -o -d "../../node_modules" -o -d "../../../node_modules" ]; then
        if hash node 2>/dev/null; then
            nodev=$(node -v)
            if [[ $COLORS == "true" ]]; then
                export node_version="%{$fg[cyan]%}$NODE_VERSION_PREFIX$nodev$NODE_VERSION_SUFIX%{$reset_color%}"
            else
                export node_version="$NODE_VERSION_PREFIX$nodev$NODE_VERSION_SUFIX"
            fi
        else
            if [[ $COLORS == "true" ]]; then
                export node_version="%{$fg[yellow]%}$NODE_VERSION_PREFIX""Node.js not found""$NODE_VERSION_SUFIX%{$reset_color%}"
            else
                export node_version="$NODE_VERSION_PREFIX""Node.js not found""$NODE_VERSION_SUFIX"
            fi
        fi
    else
        export node_version=""
    fi
}

precmd_functions+=(_node_version)
DEPENDENCES_ARCH+=( nodejs )
