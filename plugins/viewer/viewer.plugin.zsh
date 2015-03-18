#!/usr/bin/env zsh
#
htmlcat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.html
    file=/tmp/.tmp.text.html
    else
        file=$1
    fi
  html-beautify $file | `whence pygmentize` -f 256 -g
}
alias xmlcat=htmlcat

csscat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.css
    file=/tmp/.tmp.text.css
    else
        file=$1
    fi
  cssbeautify $file | `whence pygmentize` -f 256 -g 
}

jscat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.js
    file=/tmp/.tmp.text.js
    else
        file=$1
    fi
  js-beautify $file | `whence pygmentize` -f 256 -g 
}


jsoncat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.js
    file=/tmp/.tmp.text.js
    else
        file=$1
    fi
  cat $file | prettyjson
}

cppcat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.c
    file=/tmp/.tmp.text.c
    else
        file=$1
    fi
  astyle < $file | `whence pygmentize` -f 256 -g 
}
alias javacat=cppcat


hcat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]
    then
    curl -L --silent $1 > /tmp/.tmp.text.file
    file=/tmp/.tmp.text.file
    else
        file=$1
    fi
  `whence pygmentize` -f 256 -g $file
}


imgcat() {
if [ ! -z "$1" ]; then
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
        wget --quiet --output-document /tmp/.tmp.img.file $1
        convert /tmp/.tmp.img.file /tmp/.tmp.img.png
        img=/tmp/.tmp.img.png
    else
        img=$1
    fi

    if [[ $COLUMNS -gt 128 ]]; then
        width=$(( ($COLUMNS/3)*2 ))
    else
        width=$(( $COLUMNS-1 ))
    fi
    FILESIZE=$(stat -c%s "$img")
    if [[ $FILESIZE -gt 1048576 ]]; then
        \cp "$img" /tmp/.pic
        mogrify -resize 256 /tmp/.pic
        convert /tmp/.pic /tmp/.pic.png
        picture-tube --cols $width /tmp/.pic.png
        rm /tmp/.pic.png /tmp/.pic
    else
        case "$img" in
            (*.png|*.PNG)
                picture-tube --cols $width "$img"
            ;;
            (*.jpg|*.jpeg|*.gif|*.svg|*.JPG|*.JPEG|*.GIF|*.SVG)
                convert "$img" /tmp/.pic.png; picture-tube --cols $width /tmp/.pic.png; rm /tmp/.pic.png
            ;;
            (*)
                echo "This is not image"
            ;;
        esac
    fi
else
    echo "Usege: image <path-to-image>"
fi
}

mdcat() {
    if [ ! -z "$1" ]; then
        if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
            curl -L --silent $1 > /tmp/.tmp.text.file
            file=/tmp/.tmp.text.file
        else
            file=$1
        fi
        markdown $file | elinks -dump -dump-color-mode 1  
    else
        echo "Usage: mdcat <path-to-md-file-or-url>"
    fi       
}
