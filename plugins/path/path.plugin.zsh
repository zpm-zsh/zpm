#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

path() {
    echo $PATH | tr ":" "\n" | \
        awk "{ sub(\"/usr\",\"$fg_no_bold[green]/usr$reset_color\"); \
            sub(\"/bin\",\"$fg_no_bold[blue]/bin$reset_color\"); \
            sub(\"/games\",\"$fg_no_bold[red]/games$reset_color\"); \
            sub(\"/opt\",\"$fg_no_bold[cyan]/opt$reset_color\"); \
            sub(\"/sbin\",\"$fg_no_bold[magenta]/sbin$reset_color\"); \
            sub(\"/local\",\"$fg_no_bold[yellow]/local$reset_color\"); \
            print }"
}

p() {
    pa=$(pwd)
    pa=${pa//\//$fg[red]\/$fg[blue]}
    pa=$fg[blue]$pa
    echo $pa
}

_current_path() {
    local pa=$(print -Pn %2~)
    if [[ $COLORS == "true" ]]; then
        pa=${pa//\//%{$fg[red]%}\/%{$fg[blue]%}}
        export current_path="%{$fg[blue]%}$CURRENT_PATH_PREFIX$pa$CURRENT_PATH_SUFIX%{$reset_color%}"
    else
        export current_path="$CURRENT_PATH_PREFIX$pa$CURRENT_PATH_SUFIX"
    fi
}

precmd_functions+=(_current_path)


[[ -d ~/.bin ]] && export PATH=$PATH:~/.bin
[[ -d ~/.local/bin ]] && export PATH=$PATH:~/.local/bin
