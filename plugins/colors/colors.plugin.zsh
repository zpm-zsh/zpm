#!/usr/bin/env zsh

export GREP_COLOR='4;31'
export PAGER=${PAGER:-"less"}

export LESS_TERMCAP_mb=$'\E[00;32m'
export LESS_TERMCAP_md=$'\E[00;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS='-R -M'

PYGMENTIZE_THEME=${PYGMENTIZE_THEME:-"monokai"}

_pygmentize_theme(){
  if (( $+commands[pygmentize] )); then
    export LESSOPEN="|pygmentize -f 256 -O style=$PYGMENTIZE_THEME -g %s"
    alias pygmentize="pygmentize -O style=$PYGMENTIZE_THEME"
  fi
  precmd_functions=(${precmd_functions#_pygmentize_theme})
}

precmd_functions+=( _pygmentize_theme )

if (( $+commands[grc] )); then

  function as(){
    \grc --colour=auto /usr/bin/as "$@"
  }
  
  function diff(){
    \grc --colour=auto /usr/bin/diff "$@"
  }
  
  if [ -x /usr/bin/dig ]; then
    function dig(){
      \grc --colour=auto /usr/bin/dig "$@"
    }
  fi
  
  if [ -x /usr/bin/gas ]; then
    function gas(){
      \grc --colour=auto /usr/bin/gas "$@"
    }
  fi
  
  if [ -x /usr/bin/gcc ]; then
    function gcc(){
      \grc --colour=auto /usr/bin/gcc "$@"
    }
  fi
  
  if [ -x /usr/bin/g++ ]; then
    function g++(){
      \grc --colour=auto /usr/bin/g++ "$@"
    }
  fi
  
  if [ -x /usr/bin/last ]; then
    function last(){
      \grc --colour=auto /usr/bin/last "$@"
    }
  fi
  
  if [ -x /usr/bin/ld ]; then
    function ld(){
      \grc --colour=auto /usr/bin/ld "$@"
    }
  fi
  
  if [ -x /sbin/ifconfig ]; then
    function ifconfig(){
      \grc --colour=auto /sbin/ifconfig "$@"
    }
  fi
  
  # mount was in primordial Unix, but OS X and Linux have it in different paths.
  if [ -x /bin/mount ]; then
    function mount(){
      \grc --colour=auto /bin/mount "$@"
    }
  fi
  if [ -x /sbin/mount ]; then
    function mount(){
      \grc --colour=auto /sbin/mount "$@"
    }
  fi
  
  # OS X and Linux have different paths to mtr
  if [ -x /usr/local/sbin/mtr ]; then
    function mtr(){
      \grc --colour=auto /usr/local/sbin/mtr "$@"
    }
  fi
  if [ -x /usr/sbin/mtr ]; then
    function mtr(){
      \grc --colour=auto /usr/sbin/mtr "$@"
    }
  fi
  
  # OS X and Linux have different paths to netstat
  if [ -x /usr/sbin/netstat ]; then
    function netstat(){
      \grc --colour=auto /usr/sbin/netstat "$@"
    }
  fi
  if [ -x /bin/netstat ]; then
    function netstat(){
      \grc --colour=auto /bin/netstat "$@"
    }
  fi
  
  # OS X and Linux have different paths to ping, of course
  if [ -x /sbin/ping ]; then
    function ping(){
      \grc --colour=auto /sbin/ping "$@"
    }
  fi
  if [ -x /sbin/ping6 ]; then
    function ping6(){
      \grc --colour=auto /sbin/ping6 "$@"
    }
  fi
  if [ -x /bin/ping ]; then
    function ping(){
      \grc --colour=auto /bin/ping "$@"
    }
  fi
  
  if [ -x /bin/ps ]; then
    function ps(){
      \grc --colour=auto /bin/ps "$@"
    }
  fi
  
  # OS X and Linux have different paths to traceroute
  if [ -x /usr/sbin/traceroute ]; then
    function traceroute(){
      \grc --colour=auto /usr/sbin/traceroute "$@"
    }
  fi
  if [ -x /bin/traceroute ]; then
    function traceroute(){
      \grc --colour=auto /bin/traceroute "$@"
    }
  fi
  # OS X and Linux have different paths to traceroute6 too
  if [ -x /usr/sbin/traceroute6 ]; then
    function traceroute6(){
      \grc --colour=auto /usr/sbin/traceroute6 "$@"
    }
  fi
  if [ -x /bin/traceroute6 ]; then
    function traceroute6(){
      \grc --colour=auto /bin/traceroute6 "$@"
    }
  fi

fi