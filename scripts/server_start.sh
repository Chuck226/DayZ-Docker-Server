#!/bin/bash
#this script will start vanilla DayZ Standalone Server Without Mods
set -e

install_server_as_requested_user() {
    mkdir -p /home/dayz-docker/server/dayz-server
    steamcmd  +force_install_dir /home/dayz-docker/server/dayz-server/ +login "$STEAM_USERNAME" "$STEAM_PASSWORD" @NoPromptForPassword 1 +app_update 223350 +quit
}

#In this step we also need to bring back data from backup (validation/update can corrupt them)
check_if_updated() {
    if [ ! -d "/home/dayz-docker/server/dayz-server/mpmissions" ] && [ -d "/home/dayz-docker/server/savefile-backup-folder/mpmissions" ]; then
        steamcmd +force_install_dir /home/dayz-docker/server/dayz-server/ +login "$STEAM_USERNAME" +app_update 223350 +quit
        rm -rf /home/dayz-docker/server/dayz-server/mpmissions
        cp -r /home/dayz-docker/server/savefile-backup-folder/mpmissions /home/dayz-docker/server/dayz-server/
        return 0
    elif [ -d "/home/dayz-docker/server/dayz-server/mpmissions" ] && [ -d "/home/dayz-docker/server/savefile-backup-folder/mpmissions" ]; then
        steamcmd +force_install_dir /home/dayz-docker/server/dayz-server/ +login "$STEAM_USERNAME" +app_update 223350 +quit
        rm -rf /home/dayz-docker/server/dayz-server/mpmissions
        cp -r /home/dayz-docker/server/savefile-backup-folder/mpmissions /home/dayz-docker/server/dayz-server/
        return 0
    else
        return 0
    fi
    return 0
}

run_server_as_requested_user() {
    cd /home/dayz-docker/server/dayz-server/ || exit
    ./DayZServer -config=serverDZ.cfg -port=${PORT:-2302} -BEpath=battleye -profiles=profiles -dologs -adminlog -netlog -freezecheck
}


# 1. Evaluate the condition: Do we need to install?
if [ ! -d "/home/dayz-docker/server/dayz-server/mpmissions" ]; then
    install_server_as_requested_user
else
    echo "DayZ directory exists. Skipping installation step."
fi
# 2. Main loop of server start
check_if_updated
run_server_as_requested_user
