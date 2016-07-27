#!/usr/bin/env zsh


zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
#  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'


zstyle ':completion:*:(ssh|scp|sshfs|mosh):*' sort false
zstyle ':completion:*:(ssh|scp|sshfs|mosh):*' format ' %F{yellow}-- %d --%f'

zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes


zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr

zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr


zstyle ':completion:*:(ssh|scp|sshfs|mosh):*:hosts-host' ignored-patterns '*(.|:)*' loopback localhost broadcasthost 'ip6-*'
zstyle ':completion:*:(ssh|scp|sshfs|mosh):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|sshfs|mosh):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.*' '255.255.255.255' '::1' 'fe80::*' 'ff02::*'
