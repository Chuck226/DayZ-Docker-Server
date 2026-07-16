#!/bin/bash

# 1. Evaluate the condition: Do we need to install?
if [ ! -d "/servers/dayz-server" ]; then
    steamcmd +force_install_dir /servers/dayz-server/ +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 223350 +quit
else
    echo "DayZ directory exists. Skipping installation step."
fi
# 2. Start the actual server
cd /servers/dayz-server/ || exit
./DayZServer -config=serverDZ.cfg -port=2301 -BEpath=battleye -profiles=profiles -dologs -adminlog -netlog -freezecheck
