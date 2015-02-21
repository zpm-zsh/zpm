#!/usr/bin/env zsh

export COLORS=${COLORS:-"true"}
if [[ -z $MANPATH ]]; then
    export MANPATH=$(manpath)
fi
if [[ -z $ZPM ]]; then
    ZPM=true

    ZSH_COMPDUMP=${ZSH_COMPDUMP:-$HOME/.zcompdump}
    ZPM_DIR=${ZPM_DIR:-~/.zpm}

    if [ -z "$HISTFILE" ]; then
        HISTFILE=$HOME/.zsh_history
    fi

    HISTSIZE=999
    SAVEHIST=999
    if [[ "$COLORS" == "true" ]]; then
        autoload -U colors && colors
    fi
    # Some modules
    setopt prompt_subst
    zstyle ':completion::complete:*' use-cache 1
    zstyle ':completion::complete:*' cache-path ~/.cache/zsh
    autoload -U compinit && compinit




    for plugin ($plugins); do
        if [[ -d $ZPM_DIR/plugins/$plugin ]]; then
            fpath=( $ZPM_DIR/plugins/$plugin $fpath )
        else
            if [[ -d $ZPM_DIR/custom/$plugin ]]; then
                fpath=( $ZPM_DIR/custom/$plugin $fpath )
            fi
        fi
    done

    for plugin ($plugins); do
        if [[ -d $ZPM_DIR/plugins/$plugin/bin ]]; then
            path=( $ZPM_DIR/plugins/$plugin/bin $path )
        else
            if [[ -d $ZPM_DIR/custom/$plugin/bin ]]; then
                path=( $ZPM_DIR/custom/$plugin/bin $path )
            fi
        fi
    done

    for plugin ($plugins); do
        if [[ -d $ZPM_DIR/plugins/$plugin/man ]]; then
            manpath=( $ZPM_DIR/plugins/$plugin/man $manpath )
        else
            if [[ -d $ZPM_DIR/custom/$plugin/man ]]; then
                manpath=( $ZPM_DIR/custom/$plugin/man $manpath )
            fi
        fi
    done

    for plugin ($plugins); do
        if [[ -f $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh ]]; then
            source $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh 
        else
            if [[ -f $ZPM_DIR/custom/$plugin/$plugin.plugin.zsh ]]; then
                source $ZPM_DIR/custom/$plugin/$plugin.plugin.zsh
            fi
        fi
    done


    compinit


fi


function zshrc-install(){
    scp ~/.zshrc $1:.zshrc 
}
