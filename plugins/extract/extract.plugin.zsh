#!/usr/bin/env zsh

e() {
    local remove_archive
    local success
    local file_name
    local extract_dir
    if (( $# == 0 )); then
        echo "Usage: extract [-option] [file ...]"
        echo
        echo Options:
        echo "    -r, --remove    Remove archive."
    fi
    remove_archive=1
    if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]
    then
        remove_archive=0 
        shift
    fi
    while (( $# > 0 ))
    do
        if [[ ! -f "$1" ]]
        then
            echo "extract: '$1' is not a valid file" 1>&2
            shift
            continue
        fi
        success=0
        file_name="$( basename "$1" )"
        extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
        case "$1" in
            (*.tar.gz|*.tgz)
                tar fxv "$1"                               
            ;;
            (*.tar.bz2|*.tbz|*.tbz2)
                tar fxv "$1"
            ;;
            (*.tar.xz|*.txz)
                tar --xz --help &> /dev/null \
                && tar fxv "$1" \
                || xzcat "$1" | tar xvf -
            ;;
            (*.tar.zma|*.tlz)
                tar --lzma --help &> /dev/null \
                && tar fxv "$1" \
                || lzcat "$1" | tar xvf -
            ;;
            (*.tar)
                tar xvf "$1"
            ;;
            (*.gz)
                gunzip "$1"
            ;;
            (*.bz2)
                bunzip2 "$1"
            ;;
            (*.xz)
                unxz "$1"
            ;;
            (*.lzma)
                unlzma "$1"
            ;;
            (*.Z)
                uncompress "$1"
            ;;
            (*.zip|*.war|*.jar|*.crx|*.xpi)
                unzip "$1" -d $extract_dir
            ;;
            (*.rar)
                unrar x -ad "$1"
            ;;
            (*.7z|*.iso)
                7za x "$1"
            ;;
            (*.rpm)
                rpm2cpio "$1" | cpio -idmv
            ;;
            (*.exe)
                cabextract "$1" 
            ;;
            (*.deb)
                mkdir -p "$extract_dir/control"
                mkdir -p "$extract_dir/data"
                cd "$extract_dir"; ar vx "../${1}" > /dev/null
                cd control; tar fxv ../control.*
                cd ../data; tar fxv ../data.*
                cd ..; rm *.* debian-binary
                cd ..
            ;;
            (*) 
                echo "extract: '$1' cannot be extracted" 1>&2
                success=1
            ;; 
        esac
        (( success = $success > 0 ? $success : $? ))
        (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
        shift
    done
}

pk() {
if [ $1 ]
then
    case $1 in
        tbz)
            tar cjvf $2.tar.bz2 $2
        ;;
        tgz)
            tar czvf $2.tar.gz $2
        ;;
        tar)
            tar cpvf $2.tar $2
        ;;
        bz2)
            bzip $2
        ;;
        gz)
            gzip -c -9 -n $2 > $2.gz
        ;;
        zip)
            cd $2 ; zip -r ../`basename $2`.zip *; cd ..
        ;;
        xpi)
            cd $2 ; zip -r ../`basename $2`.xpi *; cd ..
        ;;
        crx)
            cd $2 ; zip -r ../`basename $2`.crx *; cd ..
        ;;
        7z) 
            7z a $2.7z $2
        ;;
        *)
            echo "'$1' cannot be packed via pk()"
        ;;
    esac
else
    echo "'$1' is not a valid file"
fi
}

zstyle ":completion:*:*:pk:*" sort false
