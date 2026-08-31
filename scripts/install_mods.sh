#!/bin/bash
#this script will install mods from workshop and do their basic setup
set -e

download_mods() {
    installed_mods=$(cat modlist.txt)

    if [ "${WORKSHOP_MODS}" == "${installed_mods}" ]; then
        ~/server/steamcmd/steamcmd.sh +force_install_dir /home/dayz-docker/server/dayz-server/ +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 223350 +quit
        return 0
    else
        echo "${WORKSHOP_MODS}" > modlist.txt
        var_mods="${WORKSHOP_MODS}"
        var_mods="${var_mods//;/ }"
        var_mod_string=""
        for i in ${var_mods}; do
            var_mod_string="${var_mod_string}+workshop_download_item 221100 ${i} "
        done
        ~/server/steamcmd/steamcmd.sh +force_install_dir /home/dayz-docker/server/dayz-server/ +login ${STEAM_USERNAME} ${STEAM_PASSWORD} ${var_mod_string} +quit
        for i in ${var_mods}; do
            ln -s /home/dayz-docker/server/dayz-server/steamapps/workshop/content/221100/"${i}" /home/dayz-docker/server/dayz-server/"${i}"
            ln -s /home/dayz-docker/server/dayz-server/steamapps/workshop/content/221100/"${i}"/keys/* /home/dayz-docker/server/dayz-server/keys/
        done

        return 0
    fi
}

mkdir -p /home/dayz-docker/server/modlist
cd /home/dayz-docker/server/modlist

if [ ! -d "/home/dayz-docker/server/modlist/modlist.txt" ]; then
    touch modlist.txt
fi

if [ -z "${WORKSHOP_MODS}" ]; then
    exit 0
else
    download_mods
    exit 0
fi