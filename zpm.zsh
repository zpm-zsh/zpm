#!/usr/bin/env zsh

if [[  "$COLORS" != true && "$COLORS" != false ]]; then # Dirty hook for Centos
    export COLORS=true
fi

if [[ -z "$MANPATH" ]]; then
    if hash manpath 2>/dev/null; then
        export MANPATH=$(manpath)
    fi
fi

if [[ "$COLORS" == "true" ]]; then
    autoload -U colors && colors
fi

if [[ -z "$SHELL" ]]; then
    export SHELL=$(which zsh)
fi

ZSH_COMPDUMP="$HOME/.zcompdump"
ZPM_DIR="${${(%):-%x}:a:h}"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=999
SAVEHIST=999

# Some modules
setopt prompt_subst
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.cache/zsh
autoload -U compinit && compinit

ZPM_PLUGIN_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/zpm/plugins
mkdir -p $ZPM_PLUGIN_DIR

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
            path=( $path $ZPM_DIR/plugins/$plugin/bin )
        fi

        if [[ -d $ZPM_DIR/plugins/$plugin/man ]]; then
            manpath=( $manpath $ZPM_DIR/plugins/$plugin/man )
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

    if [[ ! -d $ZPM_PLUGIN_DIR/$_plugin_name ]]; then
        echo "Installing $plugin from github"
        git clone --recursive "https://github.com/"$plugin".git" $ZPM_PLUGIN_DIR/$_plugin_name
    fi

    fpath=( $ZPM_PLUGIN_DIR/$_plugin_name $fpath )

    if [[ -d $ZPM_PLUGIN_DIR/$_plugin_name/bin ]]; then
        path=( $path $ZPM_PLUGIN_DIR/$_plugin_name/bin )
    fi

    if [[ -d $ZPM_PLUGIN_DIR/$_plugin_name/man ]]; then
        manpath=( $manpath $ZPM_PLUGIN_DIR/$_plugin_name/man )
    fi

    if [[ -f $ZPM_PLUGIN_DIR/$_plugin_name/$_plugin_name.plugin.zsh ]]; then
        source $ZPM_PLUGIN_DIR/$_plugin_name/$_plugin_name.plugin.zsh
    elif [[ -f $ZPM_PLUGIN_DIR/$_plugin_name/zsh-$_plugin_name.plugin.zsh ]]; then
        source $ZPM_PLUGIN_DIR/$_plugin_name/zsh-$_plugin_name.plugin.zsh
    fi
    _ZPM_Plugins+=( $_plugin_name )
    _ZPM_GitHub_Plugins+=( $_plugin_name )

}


function _ZPM_Init(){
    compinit
    precmd_functions=(${precmd_functions#_ZPM_Init})
    unset ZPM_DIR ZPM_PLUGIN_DIR

}

function _ZPM-Upgrade(){

    _ZPM_Hooks=( $_ZPM_GitHub_Plugins )

    for plugg ($_ZPM_Core_Plugins); do
        if type _$plugg-upgrade | grep 'shell function' >/dev/null; then
            _ZPM_Hooks+=($plugg)
        fi
    done

    _arguments "*: :($(echo ZPM; echo $_ZPM_Hooks))"

}

function Plug(){
    for plugin ($@); do
        _ZPM_Initialize_Plugin $plugin
    done
}


# ----------
# ZPM Upgrade Hooks
# ----------

function ZPM-Upgrade(){
_Plugins_Upgrade=()

    if [[ -z $@ ]]; then
        _Plugins_Upgrade+=($_ZPM_GitHub_Plugins)
        if [[ -d "$ZPM_DIR/.git/" ]]; then
            echo "> Updating ZPM"
            git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" checkout "$ZPM_DIR/"
            git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
            echo "Run plugin hooks"
            for plugg ($_ZPM_Core_Plugins); do
                type _$plugg-upgrade | grep -q 'shell function' && _$plugg-upgrade
            done
        else
            echo "Use package manager for upgrading ZPM"
            echo "Run plugin hooks"
            for plugg ($_ZPM_Core_Plugins); do
                type _$plugg-upgrade | grep -q 'shell function' && _$plugg-upgrade
            done
        fi
    else
        _Plugins_Upgrade+=($@)
    fi

    for i ($_Plugins_Upgrade); do
        if [[ "$i" == 'ZPM' ]]; then
            if [[ -d "$ZPM_DIR/.git/" ]]; then
                echo "> Updating ZPM"
                git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" checkout "$ZPM_DIR/"
                git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
                echo "Run plugin hooks"
                for plugg ($_ZPM_Core_Plugins); do
                    type _$plugg-upgrade | grep -q 'shell function' && _$plugg-upgrade
                done
            else
                echo "Use package manager for upgrading ZPM"
                echo "Run plugin hooks"
                for plugg ($_ZPM_Core_Plugins); do
                    type _$plugg-upgrade | grep -q 'shell function' && _$plugg-upgrade
                done
            fi
        else
            if [[ -d $ZPM_PLUGIN_DIR/$i ]]; then
                echo "> Updating: $i"
                git --git-dir="$ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$ZPM_PLUGIN_DIR/$i/" checkout "$ZPM_PLUGIN_DIR/$i/"
                git --git-dir="$ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$ZPM_PLUGIN_DIR/$i/" pull
            fi
            type _$i-upgrade | grep -q 'shell function' && _$plugg-upgrade
        fi
    done
}

compdef _ZPM-Upgrade ZPM-Upgrade

precmd_functions+=(_ZPM_Init)
