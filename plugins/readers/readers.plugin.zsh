#!/usr/bin/env zsh
DEPENDENCES_ARCH+=( curl )

DEPENDENCES_NPM+=( js-beautify )
function htmlcat() {
    if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.html)
        cat > $FILE
    else
        if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	        FILE=$(mktemp -t XXXXX.html)
            curl -L --silent "$1" > $FILE
        else
            FILE="$1"
        fi
    fi
    html-beautify $FILE | `whence pygmentize` -f 256 -g
}
alias xmlcat=htmlcat

function csscat() {
    if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.css)
        cat > $FILE
    else
        if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	        FILE=$(mktemp -t XXXXX.css)
            curl -L --silent "$1" > $FILE
        else
            FILE=$1
        fi
    fi
    css-beautify $FILE | `whence pygmentize` -f 256 -g
}

function jscat() {
    if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.js)
        cat > $FILE
    else
        if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	    	FILE=$(mktemp -t XXXXX.js)
            curl -L --silent $1 > $FILE
    	else
      		FILE=$1
    	fi
  	fi
  	js-beautify $FILE | `whence pygmentize` -f 256 -g
}

function jsoncat() {
  	if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.json)
    	cat > $FILE
  	else
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	    	FILE=$(mktemp -t XXXXX.json)
      		curl -L --silent $1 > $FILE
    	else
      		FILE=$1
    	fi
  	fi
  	cat $FILE | prettyjson
}

DEPENDENCES_ARCH+=( astyle )
function cppcat() {
  	if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.cpp)
    	cat > $FILE
  	else
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	    	FILE=$(mktemp -t XXXXX.cpp)
      		curl -L --silent $1 > $FILE
    	else
      		FILE=$1
    	fi
  	fi
  	astyle < $FILE | `whence pygmentize` -f 256 -g
}
alias javacat=cppcat

DEPENDENCES_ARCH+=( pygmentize )
function hcat() {
  	if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX)
    	cat > $FILE
  	else
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	    	FILE=$(mktemp -t XXXXX)
      		curl -L --silent $1 > $FILE
    	else
      		FILE=$1
    	fi
  	fi
  	`whence pygmentize` -f 256 -g $FILE
}

function mdcat() {
  	if [[ -z $1 ]]; then
  	    FILE=$(mktemp -t XXXXX.md)
    	cat > $FILE
  	else
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
  	    	FILE=$(mktemp -t XXXXX.md)
        	curl -L --silent $1 > $FILE
    	else
        	FILE=$1
    	fi
  	fi
    mdless --no-pager "$FILE"
}
DEPENDENCES_ARCH+=( gnupg )
function gpgcat() {
  	if [[ -z $1 ]]; then
    	FILE=$(mktemp -t XXXXX.gpg)
    	cat > $FILE
  	else
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
    		FILE=$(mktemp -t XXXXX.gpg)
        	curl -L --silent $1 > $FILE
    	else
        	FILE=$1
    	fi
  	fi
  	gpg --quiet --batch -d $FILE
}

function pdfcat() {
  	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ft"* ]]; then
    	FILE=$(mktemp -t XXXXX.pdf)
    	curl -L --silent $1 > $FILE
  	else
    	file=$1
  	fi
  	pdftotext -eol unix -nopgbrk "$FILE" -
}
DEPENDENCES_NPM+=( picture-tube )
function imgcat() {
  	if [ ! -z "$1" ]; then
    	if [[ $1 == "http:"* ]] || [[ $1 == "https:"* ]] || [[ $1 == "ftp:"* ]]; then
    		FILERAW=$(mktemp -t XXXXX.img)
    		curl -L --silent $1 > $FILERAW
    	else
        	FILERAW="$1"
    	fi

    	if [[ $COLUMNS -gt 128 ]]; then
        	width=$(( ($COLUMNS/3)*2 ))
    	else
        	width=$(( $COLUMNS-1 ))
    	fi

    	FILESIZE=$(stat -c%s "$FILERAW")
    	FILE=$(mktemp -t XXXXX.png)
    	convert $FILERAW $FILE

    	if [[ $FILESIZE -gt 1048576 ]]; then
        	mogrify -resize $width $FILE
        	picture-tube --cols $width $FILE
    	else
        	picture-tube --cols $width $FILE
    	fi
  	else
    	echo "Usege: image <path-to-image>"
  	fi
}
DEPENDENCES_NPM+=( picture-tube js-beautify )
