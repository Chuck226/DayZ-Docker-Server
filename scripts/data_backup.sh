#!/bin/bash
#this script will create backup of server savefiles before start (currently only one backup state available)
set -e
create-backup-folder() {
    if [ ! -d "/home/dayz-docker/server/savefile-backup-folder" ]; then
        mkdir -p /home/dayz-docker/server/savefile-backup-folder/
    fi
    return 0
}

perform-backup() {
    if [ ! -d "/home/dayz-docker/server/dayz-server/mpmissions" ]; then
        return 0
    else
        rm -rf /home/dayz-docker/server/savefile-backup-folder/*
        cp -r /home/dayz-docker/server/dayz-server/mpmissions /home/dayz-docker/server/savefile-backup-folder/
    fi
    return 0
}

create-backup-folder
perform-backup
exit 0