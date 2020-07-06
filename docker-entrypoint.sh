#!/bin/bash
#Set environment.

# Main binaries & their directories.
HOME_DIR=/home/steam
GAME_DIR=$HOME_DIR/$USER
SRCDS_BIN=$GAME_DIR/srcds_run
STEAMCMD_BIN=/usr/games/steamcmd

# Default server parameters.

SERVER_PARAMS="+sv_pure 1 +map ctf_2fort +maxplayers 24"

# Logging
TIME=`date "+%Y-%m-%d %H:%M:%S"`
LOG="[Entrypoint] [$TIME]"

function permfix {
  echo "$LOG Changing permissions to $UID and $GID..."
  if [ $UID != 1000 ]; then
    sudo groupadd -g $GID $USER
    sudo useradd -m -u $UID -g $GID $USER
    sudo echo $USER' ALL=(ALL:ALL) NOPASSWD:ALL' > sudouser
    sudo echo 'steam ALL=(ALL:ALL) NOPASSWD:ALL' >> sudouser
    sudo cp sudouser /etc/sudoers.d
    sudo find $GAME_DIR ! -user $UID -exec sudo chown -R $UID:$GID {} \;
    sudo find $HOME_DIR/.steam ! -user $UID -exec sudo chown -R $UID:$GID {} \;
    echo "$LOG Finished with permissions!"
  else
    sudo chown -R steam:steam {$GAME_DIR,$HOME_DIR/.steam}
  fi
}

#Update function.
function update {
  echo "$LOG Starting update."
  permfix
  sudo -u $USER $STEAMCMD_BIN +login anonymous +force_install_dir /home/steam/tf2 +app_update 232250 +quit
  echo "$LOG Update finished!"
}


#Main function.
function main {
  echo "$LOG Starting main function..."
  if [ "$UPDATE" ]; then
    update
  fi
  permfix
  MSG="Everything looks good! Starting ${USER^^} server with"
  if [ -z "$1" ]; then
    echo "$LOG $MSG $SERVER_PARAMS..."
  else
    SERVER_PARAMS="$1"
    echo "$LOG $MSG $SERVER_PARAMS..."
  fi
  sudo -u $USER $SRCDS_BIN -console -game tf $SERVER_PARAMS
}

if [ $1 == "/bin/bash" ]; then # tunnel into bash incase we need it
  echo "$LOG Tunneling to /bin/bash!"
  /bin/bash
  exit
fi

if [ -f "$SRCDS_BIN" ]; then
  echo "$LOG ${USER^^} detected! Proceeding with launch."
  main
else
  echo "$LOG ${USER^^} not detected! Starting update."
  update
  main
fi
