#!/usr/bin/env zsh

function s(){
    number=`wc -l</proc/mounts`
    for line in {1..$number}; do
        mount=`sed $line'!d' /proc/mounts`
        if [[ $mount == *sshfs* ]]; then

            host=`sed $line'!d' /proc/mounts | awk -F  ":" '{print $1}'`
            text=`sed $line'!d' /proc/mounts | awk '{print $2}'`
            text="echo \$\'"$(echo $text|sed -e 's|\\|\\\\|g')"\'"
            text=$(eval "echo $(eval $text)")
            read text < <(echo $text)
            if [[ `pwd` == $text* ]]; then
                ssh "$host" "$@"
            fi
        fi
    done
}
