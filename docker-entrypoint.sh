#!/bin/bash
#Set environment.
SRCDS_BIN=/home/steam/tf2/srcds_run
STEAMCMD_BIN=/usr/games/steamcmd

function update {
  $STEAMCMD_BIN +login anonymous +force_install_dir /home/steam/tf2 +app_update 232250
}

function main {
  if [ -z "$1" ]; then
    $SRCDS_BIN -console -game tf +sv_pure 1 +map ctf_2fort +maxplayers 24
  else
    $SRCDS_BIN -console -game tf $1
  fi
}


if [ -f "$SRCDS_BIN" ]; then
  echo "TF2 not detected! Starting update."
  update
  main
else
  echo "TF2 detected! Proceeding with launch."
  main
fi
