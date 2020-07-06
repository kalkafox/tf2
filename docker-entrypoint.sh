#!/bin/bash
#Set environment.
HOME_DIR=/home/steam
GAME_DIR=/home/steam/$USER
SRCDS_BIN=$GAME_DIR/srcds_run
STEAMCMD_BIN=/usr/games/steamcmd

function permfix {
  echo "Changing permissions to $UID and $GID..."
  if [ $UID != 1000 ]; then
    sudo groupadd -g $GID $USER
    sudo useradd -m -u $UID -g $GID $USER
    sudo echo $USER' ALL=(ALL:ALL) NOPASSWD:ALL' > sudouser
    sudo echo 'steam ALL=(ALL:ALL) NOPASSWD:ALL' >> sudouser
    sudo cp sudouser /etc/sudoers.d
    sudo chown -R $UID:$GID {$GAME_DIR,$HOME_DIR/.steam}
  else
    sudo chown -R steam:steam {$GAME_DIR,$HOME_DIR/.steam}
  fi
}

#Update function.
function update {
  permfix
  sudo -u $USER $STEAMCMD_BIN +login anonymous +force_install_dir /home/steam/tf2 +app_update 232250 +quit
}


#Main function.
function main {
  permfix
  sudo ln -s $HOME_DIR/tf2/bin $HOME_DIR/.steam/sdk32
  if [ -z "$1" ]; then
    sudo -u $USER $SRCDS_BIN -console -game tf +sv_pure 1 +map ctf_2fort +maxplayers 24
  else
    sudo -u $USER $SRCDS_BIN -console -game tf $1
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
