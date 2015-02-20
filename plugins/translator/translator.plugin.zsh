#!/usr/bin/env zsh

translator() {
  LBUFFER=$( wget -U "Mozilla/5.0" -qO - "http://translate.google.com/translate_a/t?client=t&text=$LBUFFER&sl=auto&tl=ru" | sed 's/\[\[\[\"//' | cut -d \" -f 1 )
}
zle -N translator
bindkey '^T' translator

