#!/bin/bash
#this script will create backup of server ssavefiles before start (currently only one backup available)
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

create-backup-folder() {
    if [ ! -d "/servers/savefile-backup-folder" ]; then
        mkdir -p /servers/savefile-backup-folder/
        chown "$PUID:$PGID" /servers/savefile-backup-folder || true
    fi
    return 0
}

perform-backup() {
    if [ ! -d "/servers/dayz-server/mpmissions" ]; then
        return
    else
        rm -rf /servers/savefile-backup-folder/*
        cp -r /servers/dayz-server/mpmissions /servers/savefile-backup-folder/
    fi
    return 0
}

create-backup-folder
perform-backup
exit 0