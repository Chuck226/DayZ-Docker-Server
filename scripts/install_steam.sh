#!/bin/bash
#this script will install steam
set -e

is_steam_installed() {
    if [ ! -d "/home/dayz-docker/server" ]; then
        mkdir -p /home/dayz-docker/server/steamcmd && cd /home/dayz-docker/server/steamcmd
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
        return 0
    fi
    return 0
}

is_steam_installed
exit 0
