#!/usr/bin/env zsh



if [[  $COLORS != true && $COLORS != false ]]; then
    export COLORS=true
fi
    
if [[ -z $MANPATH ]]; then
    if hash manpath 2>/dev/null; then
        export MANPATH=$(manpath)
    else
        export MANPATH=(  )
    fi
fi
    
if [[ -z $ZSH_COMPDUMP ]]; then
    export ZSH_COMPDUMP=$HOME/.zcompdump
fi
    
if [[ -z $ZPM_DIR ]]; then
    export ZPM_DIR=$HOME/.zpm
fi

if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=9999
SAVEHIST=9999

if [[ "$COLORS" == "true" ]]; then
    autoload -U colors && colors
fi

# Some modules
setopt prompt_subst
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.cache/zsh
autoload -U compinit && compinit

_ZPM_update_hooks=()
_ZPM_End_hooks=()

function _ZPM_End_hook(){

    if [[ -z $_ZPM_End ]]; then
        for ZPM_End_hook ( $_ZPM_End_hooks ); do
            $ZPM_End_hook
        done
        compinit
        _ZPM_End=true
    fi
    
}

precmd_functions+=(_ZPM_End_hook)

function zpm-install(){

    ssh $1 "git clone --recursive https://github.com/horosgrisa/ZPM ~/.zpm; ln -s ~/.zpm/zshrc-example ~/.zshrc"

}

function zshrc-install(){

    scp ~/.zshrc $1:.zshrc

}

function zpm-compile(){

    find $ZPM_DIR/plugins -name "*.zsh" | while read line
    do
        zcompile $line
    done

}

function zpm-update(){

    _olddir=`pwd`
    cd $ZPM_DIR
    echo "Updating ZPM"
    git pull
    cd custom
    for i in *
    do
        echo "> Updating: $i"
        cd $i
        git pull
        cd ..
    done
    cd $_olddir
    for zpm_update_hook ( $_ZPM_update_hooks ); do
        $zpm_update_hook
    done
    unset _olddir

}

function Plug(){

    for plugin ($@); do
        if [[ $plugin == */* ]]; then
            if [[ ! -d $ZPM_DIR/custom/${plugin##*\/} ]]; then
                echo "Installing plugin from github"
                git clone --recursive "https://github.com/"$plugin".git" $ZPM_DIR/custom/${plugin##*\/}
            fi
        fi
    done
    
    for plugin ($@); do
        if [[ -d $ZPM_DIR/plugins/$plugin ]]; then
            fpath=( $ZPM_DIR/plugins/$plugin $fpath )
        else
            if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/} ]]; then
                fpath=( $ZPM_DIR/custom/${plugin##*\/} $fpath )
            fi
        fi
    done
    
    for plugin ($@); do
        if [[ -d $ZPM_DIR/plugins/$plugin/bin ]]; then
            path=( $ZPM_DIR/plugins/$plugin/bin $path )
        else
            if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/}/bin ]]; then
                path=( $ZPM_DIR/custom/${plugin##*\/}/bin $path )
            fi
        fi
    done
    
    for plugin ($@); do
        if [[ -d $ZPM_DIR/plugins/$plugin/man ]]; then
            manpath=( $ZPM_DIR/plugins/$plugin/man $manpath )
        else
            if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/}/man ]]; then
                manpath=( $ZPM_DIR/custom/${plugin##*\/}/man $manpath )
            fi
        fi
    done
    
    for plugin ($@); do
        if [[ ! $plugin == */* ]] && [[ -f $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh ]]; then
            source $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh 
        fi
    done

    for plugin ($@); do
        if [[ $plugin == */* ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/}.plugin.zsh ]]; then
            source $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/}.plugin.zsh 
        fi
    done

    for plugin ($@); do
        if [[ $plugin == */*.plugin.zsh ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/} ]]; then
            source $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/} 
        fi
    done

    for plugin ($@); do
        if [[ $plugin == */zsh-* ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${${plugin##*\/}:4}.plugin.zsh ]]; then
            source $ZPM_DIR/custom/${plugin##*\/}/${${plugin##*\/}:4}.plugin.zsh
        fi
    done

    for plugin ($@); do
        if [[ $plugin == */zsh-*.plugin.zsh ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${${plugin##*\/}:4} ]]; then
            source $ZPM_DIR/custom/${plugin##*\/}/${${plugin##*\/}:4}
        fi
    done

}

function _ZPM_Hosts(){

    _arguments \
        ':remote:_hosts'

}

compdef _ZPM_Hosts zshrc-install
compdef _ZPM_Hosts zpm-install

zstyle ":completion:*:*:zshrc-install:*" sort false
zstyle ":completion:*:*:zpm-install:*" sort false
