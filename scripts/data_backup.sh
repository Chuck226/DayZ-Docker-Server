#!/bin/bash
#this script will create backup of server savefiles before start (currently only one backup state available)
set -e
create-backup-folder() {
    if [ ! -d "/home/dayz-docker/savefile-backup-folder" ]; then
        mkdir -p /home/dayz-docker/savefile-backup-folder/
    fi
    return 0
}

perform-backup() {
    if [ ! -d "/home/dayz-docker/dayz-server/mpmissions" ]; then
        return
    else
        rm -rf /home/dayz-docker/savefile-backup-folder/*
        cp -r /home/dayz-docker/dayz-server/mpmissions /home/dayz-docker/savefile-backup-folder/
    fi
    return 0
}

create-backup-folder
perform-backup
exit 0