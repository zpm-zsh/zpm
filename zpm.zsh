#!/usr/bin/env zsh

if [[  "$COLORS" != true && "$COLORS" != false ]]; then
    export COLORS=true
fi

if [[ -z "$MANPATH" ]]; then
    if hash manpath 2>/dev/null; then
        export MANPATH=$(manpath)
    fi
fi

if [[ -z "$ZSH_COMPDUMP" ]]; then
    export ZSH_COMPDUMP="$HOME/.zcompdump"
fi

if [[ -z "$ZPM_DIR" ]]; then
    export ZPM_DIR="$HOME/.zpm"
fi

if [ -z "$HISTFILE" ]; then
    HISTFILE="$HOME/.zsh_history"
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

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()
_ZPM_GitHub_Plugins+=()
_ZPM_Core_Plugins+=()



_ZPM_Initialize_Plugin(){

    local plugin=$1
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

        _ZPM_Plugins+=( $plugin )
        _ZPM_Core_Plugins+=( $plugin )


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
    _ZPM_Plugins+=( $_plugin_name )
    _ZPM_GitHub_Plugins+=( $_plugin_name )

}

function Plug(){
    for plugin ($@); do
        _ZPM_Initialize_Plugin $plugin
    done
}

function _ZPM_Init(){
    compinit
    precmd_functions=(${precmd_functions#_ZPM_Init})
}


# ----------
# ZPM Functions
# ----------


function ZPM-Compile(){
    find $ZPM_DIR/ -name "*.zsh" | while read line
    do
        zcompile $line
    done
}



# ----------
# ZPM Upgrade Hooks
# ----------

function ZPM-Upgrade(){
_Plugins_Upgrade=()

    if [[ -z $@ ]]; then
        echo "> Updating ZPM"
        git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
        _Plugins_Upgrade+=($_ZPM_Plugins)
        for plugg ($_ZPM_Core_Plugins); do
            _$plugg-update-hook 2>/dev/null
        done
    else
        _Plugins_Upgrade+=($@)
    fi

    for i ($_Plugins_Upgrade); do
        if [[ "$i" == 'core' ]]; then
            echo "> Updating ZPM"
            git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
            for plugg ($_ZPM_Core_Plugins); do
                _$plugg-update-hook 2>/dev/null
            done
        else
            if [[ -d $ZPM_DIR/custom/$i ]]; then
                echo "> Updating: $i"
                git --git-dir="$ZPM_DIR/custom/$i/.git/" --work-tree="$ZPM_DIR/custom/$i/" pull
            fi
            $i-upgrade-hook 2>/dev/null || true
        fi
    done
}


function _ZPM-Upgrade(){

    _arguments "*: :($(echo core; echo $_ZPM_GitHub_Plugins))"

}

compdef _ZPM-Upgrade ZPM-Upgrade

precmd_functions+=(_ZPM_Init)
