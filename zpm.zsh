#!/usr/bin/env zsh

if [[  $COLORS != true && $COLORS != false ]]; then
    export COLORS=true
fi

if [[ -z $MANPATH ]]; then
    if hash manpath 2>/dev/null; then
        export MANPATH=$(manpath)
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

_ZPM_Initialize_Plugin(){

    plugin=$1
    if [[ ! "$plugin" == */* ]]; then

        fpath=( $ZPM_DIR/plugins/$plugin $fpath )

        if [[ -d $ZPM_DIR/plugins/$plugin/bin ]]; then
            path=( $ZPM_DIR/plugins/$plugin/bin $path )
        fi

        if [[ -d $ZPM_DIR/plugins/$plugin/man ]]; then
            manpath=( $ZPM_DIR/plugins/$plugin/man $manpath )
        fi
        
        if [[ -f $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh ]]; then
            source $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh
        fi

        return
    fi

    _plugin_name=$plugin
    _plugin_name=${_plugin_name##*\/}
    if [[ $_plugin_name == zsh-*  ]]; then
        _plugin_name=${_plugin_name:4}
    fi
    if [[ $_plugin_name == *.zsh  ]]; then
        _plugin_name=${_plugin_name:0:-4}
    fi
    if [[ $_plugin_name == *.plugin  ]]; then
        _plugin_name=${_plugin_name:0:-7}
    fi

    if [[ ! -d $ZPM_DIR/custom/$_plugin_name ]]; then
        echo "Installing $plugin from github"
        git clone --recursive "https://github.com/"$plugin".git" $ZPM_DIR/custom/$_plugin_name
    fi

    fpath=( $ZPM_DIR/custom/$_plugin_name $fpath )

    if [[ -d $ZPM_DIR/custom/$_plugin_name/bin ]]; then
        path=( $ZPM_DIR/custom/$_plugin_name/bin $path )
    fi

    if [[ -d $ZPM_DIR/custom/$_plugin_name/man ]]; then
        manpath=( $ZPM_DIR/custom/$_plugin_name/man $manpath )
    fi

    if [[ -f $ZPM_DIR/custom/$_plugin_name/$_plugin_name.plugin.zsh ]]; then
        source $ZPM_DIR/custom/$_plugin_name/$_plugin_name.plugin.zsh
    fi

    if [[ -f $ZPM_DIR/custom/$_plugin_name/zsh-$_plugin_name.plugin.zsh ]]; then
        source $ZPM_DIR/custom/$_plugin_name/zsh-$_plugin_name.plugin.zsh
    fi

}

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
        _ZPM_Initialize_Plugin $plugin
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
