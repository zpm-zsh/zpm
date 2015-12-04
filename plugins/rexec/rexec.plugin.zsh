#!/usr/bin/env zsh

function s(){

    number=`wc -l</proc/mounts`
    for line in {1..$number}; do
        mount=`sed $line'!d' /proc/mounts`
        if [[ $mount == *fuse.sshfs* ]]; then
            host=$(echo $mount | awk '{print $1}' | awk -F':' '{print $1}')
            remotepath=$(echo $mount | awk '{print $1}' | awk -F':' '{print $2}')
            localpath=$(echo $mount | awk '{print $2}')
            localsuffix=${PWD#$localpath}
            remotepath=$remotepath$localsuffix
            script="""
            export LS_COLORS=\"$LS_COLORS\"
            export LANG=\"$LANG\"
            export LANGUAGE=\"$LANGUAGE\"
            export EDITOR=\"$EDITOR\"
            export PAGER=\"$PAGER\"
            export LESS=\"$LESS\"
            export LESSOPEN=\"$LESSOPEN\"
            export GREP_COLOR=\"$GREP_COLOR\"
            cd $remotepath
            $@
            """
            if [[ `pwd` == $text* ]]; then
                ssh $host $script
            fi
        fi
    done
}
