#!/usr/bin/env zsh

zstyle ':completion:*:*:*:users' ignored-patterns \
bin daemon mail ftp http uuidd dbus nobody \
git polkitd dnsmasq sddm avahi rtkit colord \
systemd-journal-gateway systemd-timesync systemd-network systemd-bus-proxy \
systemd-resolve systemd-journal-remote systemd-journal-upload 

zstyle ':completion:*:*:*:groups' ignored-patterns \
bin daemon sys adm tty disk lp mem kmem wheel ftp mail uucp log \
utmp locate rfkill smmsp proc http games lock uuidd dbus network video audio optical floppy \
storage scanner input power nobody users git polkitd dnsmasq sddm avahi rtkit mysql colord docker \
systemd-journal systemd-journal-gateway systemd-timesync systemd-network systemd-bus-proxy systemd-resolve systemd-journal-remote systemd-journal-upload
