#!/bin/bash
#this script will start vanilla DayZ Standalone Server Without Mods
set -e

install_server_as_requested_user() {
    mkdir -p /home/dayz-docker/dayz-server
    steamcmd +force_install_dir /home/dayz-docker/dayz-server/ +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 223350 +quit
}

run_server_as_requested_user() {
    cd /home/dayz-docker/dayz-server/ || exit
    ./DayZServer -config=serverDZ.cfg -port=${PORT:-2302} -BEpath=battleye -profiles=profiles -dologs -adminlog -netlog -freezecheck
}


# 1. Evaluate the condition: Do we need to install?
if [ ! -d "/home/dayz-docker/dayz-server/mpmissions" ]; then
    install_server_as_requested_user
else
    echo "DayZ directory exists. Skipping installation step."
fi
# 2. Start the actual server
run_server_as_requested_user
