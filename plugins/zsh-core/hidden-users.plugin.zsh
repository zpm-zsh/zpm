#!/usr/bin/env zsh

zstyle ':completion:*:*:*:users' ignored-patterns \
polkitd avahi colord dbus nobody rtkit uuidd bin daemon sddm \
http git ntp ftp mysql mail dnsmasq \
systemd systemd-journal-gateway systemd-journal-remote systemd-journal-upload \
systemd-timesync systemd-resolve systemd-network systemd-bus-proxy

zstyle ':completion:*:*:*:groups' ignored-patterns \
wheel
