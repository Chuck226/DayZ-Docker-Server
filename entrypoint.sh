#!/bin/bash
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}


bash /scripts/data_backup.sh
bash /scripts/server_start.sh
