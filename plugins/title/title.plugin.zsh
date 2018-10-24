
_show_title(){
echo -n -e "\033]0;$(eval print -Pn $PROMPT_TITLE | sed 's/\x1b\[[0-9;]*m//g')\007"

}

_show_title
precmd_functions+=(_show_title)
