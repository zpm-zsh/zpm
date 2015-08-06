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

ZSH_COMPDUMP="$HOME/.zcompdump"
ZPM_DIR="${0:a:h}"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=9999
SAVEHIST=9999



# Some modules
setopt prompt_subst
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.cache/zsh
autoload -U compinit && compinit
mkdir -p $HOME/.local/share/zpm/plugins

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

    if [[ ! -d $HOME/.local/share/zpm/plugins/$_plugin_name ]]; then
        echo "Installing $plugin from github"
        git clone --recursive "https://github.com/"$plugin".git" $HOME/.local/share/zpm/plugins/$_plugin_name
    fi

    fpath=( $HOME/.local/share/zpm/plugins/$_plugin_name $fpath )

    if [[ -d $HOME/.local/share/zpm/plugins/$_plugin_name/bin ]]; then
        path=( $path $HOME/.local/share/zpm/plugins/$_plugin_name/bin )
    fi

    if [[ -d $HOME/.local/share/zpm/plugins/$_plugin_name/man ]]; then
        manpath=( $manpath $HOME/.local/share/zpm/plugins/$_plugin_name/man )
    fi

    if [[ -f $HOME/.local/share/zpm/plugins/$_plugin_name/$_plugin_name.plugin.zsh ]]; then
        source $HOME/.local/share/zpm/plugins/$_plugin_name/$_plugin_name.plugin.zsh
    elif [[ -f $HOME/.local/share/zpm/plugins/$_plugin_name/zsh-$_plugin_name.plugin.zsh ]]; then
        source $HOME/.local/share/zpm/plugins/$_plugin_name/zsh-$_plugin_name.plugin.zsh
    fi
    _ZPM_Plugins+=( $_plugin_name )
    _ZPM_GitHub_Plugins+=( $_plugin_name )

}


function _ZPM_Init(){
    compinit
    precmd_functions=(${precmd_functions#_ZPM_Init})
}

function _ZPM-Upgrade(){

    _arguments "*: :($(echo core; echo $_ZPM_GitHub_Plugins))"

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
        echo "> Updating ZPM"
        git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
        _Plugins_Upgrade+=($_ZPM_Plugins)
        for plugg ($_ZPM_Core_Plugins); do
            _$plugg-upgrade 2>/dev/null
        done
    else
        _Plugins_Upgrade+=($@)
    fi

    for i ($_Plugins_Upgrade); do
        if [[ "$i" == 'core' ]]; then
            echo "> Updating ZPM"
            git --git-dir="$ZPM_DIR/.git/" --work-tree="$ZPM_DIR/" pull
            for plugg ($_ZPM_Core_Plugins); do
                _$plugg-upgrade 2>/dev/null
            done
        else
            if [[ -d $HOME/.local/share/zpm/plugins/$i ]]; then
                echo "> Updating: $i"
                git --git-dir="$HOME/.local/share/zpm/plugins/$i/.git/" --work-tree="$HOME/.local/share/zpm/plugins/$i/" pull
            fi
            $i-upgrade 2>/dev/null || true
        fi
    done
}



compdef _ZPM-Upgrade ZPM-Upgrade

precmd_functions+=(_ZPM_Init)
