#!/usr/bin/env zsh


zstyle ':completion:*:*:*:users' ignored-patterns \
adm avahi beaglidx bin cacti canna clamav daemon \
dbus distcache dovecot fax ftp games gkrellmd gopher \
hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
mailman mailnull mldonkey nagios \
named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
operator pcap postfix postgres privoxy pulse pvm quagga radvd \
avahi-autoipd dnsmasq hplip libuuid proxy speech-dispatcher syslog \
backup festival irc list sshd usbmux colord debian-spamd kdm man gdm  \
uucp sync rtkit kernoops gnats messagebus adm audio plugdev  \
sambashare libvirt-dnsmasq libvirt-qemu mongodb mysql motion \
freeswitch landscape red5 redis lightdm nvidia-persistenced smmsp \
davfs2 debian-tor statd saned sys smmta winbindd_priv vboxusers \
nova uuidd whoopsie systemd-bus-proxy sddm systemd \
guest systemd-network systemd-resolve systemd-timesync

zstyle ':completion:*:*:*:groups' ignored-patterns \
uucp sync rtkit kernoops gnats messagebus adm audio plugdev  \
cdrom dip lpadmin postgres sambashare libvirtd disk admin sudo \
winbindd_priv vboxusers dialout
