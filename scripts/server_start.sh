#!/bin/bash
#this script will start vanilla DayZ Standalone Server Without Mods
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}


install_server_as_requested_user() {
    mkdir -p /servers/dayz-server
    chown "$PUID:$PGID" /servers/dayz-server
    gosu "$PUID:$PGID" env HOME=/servers/dayz-server steamcmd +force_install_dir /servers/dayz-server/ +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 223350 +quit
}

run_server_as_requested_user() {
    cd /servers/dayz-server/ || exit
    ./DayZServer -config=serverDZ.cfg -port=${PORT:-2302} -BEpath=battleye -profiles=profiles -dologs -adminlog -netlog -freezecheck
}


# 1. Evaluate the condition: Do we need to install?
if [ ! -d "/servers/dayz-server/mpmissions" ]; then
    install_server_as_requested_user
else
    echo "DayZ directory exists. Skipping installation step."
fi
# 2. Start the actual server
run_server_as_requested_user
