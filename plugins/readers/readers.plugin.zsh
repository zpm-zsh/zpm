#!/usr/bin/env zsh

function htmlcat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.html
    file=/tmp/.tmp.text.html
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.html
      file=/tmp/.tmp.text.html
    else
      file=$1
    fi
  fi
  html-beautify $file | `whence pygmentize` -f 256 -g
}
alias xmlcat=htmlcat

function csscat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.css
    file=/tmp/.tmp.text.css
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.css
      file=/tmp/.tmp.text.css
    else
      file=$1
    fi
  fi
  cssbeautify $file | `whence pygmentize` -f 256 -g 
}

function jscat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.css
    file=/tmp/.tmp.text.css
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.js
      file=/tmp/.tmp.text.js
    else
      file=$1
    fi
  fi
  js-beautify $file | `whence pygmentize` -f 256 -g 
}

function jsoncat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.js
    file=/tmp/.tmp.text.js
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.js
      file=/tmp/.tmp.text.js
    else
      file=$1
    fi
  fi
  cat $file | prettyjson
}

function cppcat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.cpp
    file=/tmp/.tmp.text.cpp
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.cpp
      file=/tmp/.tmp.text.c
    else
      file=$1
    fi
  fi
  astyle < $file | `whence pygmentize` -f 256 -g 
}
alias javacat=cppcat

function hcat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.file
    file=/tmp/.tmp.text.file
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
      curl -L --silent $1 > /tmp/.tmp.text.file
      file=/tmp/.tmp.text.file
    else
      file=$1
    fi
  fi
  `whence pygmentize` -f 256 -g $file
}

function mdcat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.md
    file=/tmp/.tmp.text.md
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
        curl -L --silent $1 > /tmp/.tmp.text.md
        file=/tmp/.tmp.text.md
    else
        file=$1
    fi
  fi  
  markdown $file | elinks -dump -dump-color-mode 1  
}

function pdfcat() {
  if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ft"* ]]; then
    curl -L --silent $1 > /tmp/.tmp.pdf
    file=/tmp/.tmp.pdf
  else
    file=$1
  fi
  pdftotext -f 13 -l 17 -layout -opw supersecret -upw secret -eol unix -nopgbrk "$file" -
}

function imgcat() {
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


function gpgcat() {
  if [[ -z $1 ]]; then
    cat >/tmp/.tmp.text.gpg
    file=/tmp/.tmp.text.gpg
  else
    if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
        curl -L --silent $1 > /tmp/.tmp.text.gpg
        file=/tmp/.tmp.text.gpg
    else
        file=$1
    fi
  fi  
  gpg --quiet --batch -d $file 
}

