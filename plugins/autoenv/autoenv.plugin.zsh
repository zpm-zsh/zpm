#!/usr/bin/env zsh


if [[ -z $AUTOENV_AUTH_FILE ]]; then
    AUTOENV_AUTH_FILE=~/.autoenv_authorized
fi

if [[ -z $AUTOENV_COLORED ]]; then
    AUTOENV_COLORED=true
fi

add_auth_file(){
  if which shasum &> /dev/null
  then hash=$(shasum "$1" | cut -d' ' -f 1)
  else hash=$(sha1sum "$1" | cut -d' ' -f 1)
  fi
  echo "$1:$hash" >> $AUTOENV_AUTH_FILE
}

check_and_run(){
  if [[ $COLORS == true ]]
  then
    echo -e "\033[01;38;05;34m> \033[01;31mWARNING\033[0m"
    echo -e "\033[01;38;05;34m>\033[0m \033[38;05;68mThis is the first time you are about to source \033[01;38;05;136m\"\033[01;31m$1\033[01;38;05;136m\"\033[0m"
     echo
     echo -e "\033[01;38;05;214m----------------\033[0m"
    if hash pygmentize 2>/dev/null
    then
      echo
      cp $1 /tmp/.autoenv.sh
      pygmentize -f 256 -g /tmp/.autoenv.sh
    else
      echo -e "\033[32m"
      cat $1
    fi
    echo
    echo -e "\033[01;38;05;214m----------------\033[0m"
    echo
    echo -ne "\033[38;05;68mAre you sure you want to allow this? \033[01;38;05;136m(\033[01;38;05;34my\033[01;38;05;214m/\033[01;31mN\033[01;38;05;136m) \033[0m"
  else
        echo "> WARNING"
        echo "> This is the first time you are about to source \"$1\""
        echo
        echo "----------------"
        echo
        cat $1
        echo
        echo "----------------"
        echo
        echo -n "Are you sure you want to allow this? (y/N)"
  fi
  read answer
  if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]
  then
    add_auth_file $1
      source $1
    fi
}

check_and_exec(){
  if which shasum &> /dev/null
  then hash=$(shasum "$1" | cut -d' ' -f 1)
  else hash=$(sha1sum "$1" | cut -d' ' -f 1)
  fi
  if grep "$1:$hash" "$AUTOENV_AUTH_FILE" >/dev/null 2>/dev/null
  then
    source $1
  else
    check_and_run $1
  fi
}

autoenv_init(){
  if [[ $PWD == *$OLDPWD* ]] || [[ $PWD != *$OLDPWD* ]]
  then
    if [[ $PWD != $OLDPWD ]]
    then
      if [[ -f $PWD/.env ]]
      then
        check_and_exec $PWD/.env
      fi
    fi
  fi

  if [[ $OLDPWD == *$PWD* ]] || [[ $PWD != *$OLDPWD* ]]
  then
    if [[ $PWD != $OLDPWD ]]
    then
      if [[ -f $OLDPWD/.out ]]
      then
        check_and_exec $OLDPWD/.out
      fi
    fi
  fi
}

chpwd_functions+=( autoenv_init )
