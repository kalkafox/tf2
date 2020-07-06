#!/bin/bash
#Set environment.
HOME_DIR=/home/steam
TF2_DIR=/home/steam/tf2
SRCDS_BIN=$TF2_DIR/srcds_run
STEAMCMD_BIN=/usr/games/steamcmd

function permfix {
  echo "Changing permissions to $UID and $GID..."
  if [ $UID != 1000 ]; then
    sudo groupadd -g $GID sharedsrcds
    sudo usermod -aG $GID steam
    sudo chown -R $UID:$GID /home/steam/
  else
    sudo chown -R steam:steam /home/steam/
  fi
}

#Update function.
function update {
  permfix
  sudo $STEAMCMD_BIN +login anonymous +force_install_dir /home/steam/tf2 +app_update 232250 +quit
}


#Main function.
function main {
  permfix
  sudo ln -s $HOME_DIR/tf2/bin $HOME_DIR/.steam/sdk32
  if [ -z "$1" ]; then
    $SRCDS_BIN -console -game tf +sv_pure 1 +map ctf_2fort +maxplayers 24
  else
    $SRCDS_BIN -console -game tf $1
  fi
}

if [ $1 == "/bin/bash" ]; then # tunnel into bash incase we need it
  /bin/bash
  exit
fi

if [ -f "$SRCDS_BIN" ]; then
  echo "TF2 detected! Proceeding with launch."
  main
else
  echo "TF2 not detected! Starting update."
  update
  main
fi
