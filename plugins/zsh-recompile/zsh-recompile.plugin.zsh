#!/usr/bin/env zsh

zsh-recompile () {
    autoload -U zrecompile
    zrecompile -p ~/.zshrc ~/.zsh/*.zsh
    cd $ZPM_DIR 
    find -name "*.zsh" | while read line
    do
        zrecompile -p $line
    done

    [[ -e ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    rm -fv ~/.z*.zwc.old
}
