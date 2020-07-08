#!/bin/bash
#Set environment.

# Main binaries & their directories.
HOME_DIR=/home/steam
GAME_DIR=$HOME_DIR/$USER
SRCDS_BIN=$GAME_DIR/srcds_run
STEAMCMD_BIN=/usr/games/steamcmd
PERMS=$@

# Logging

log() {
  echo "[ENTRYPOINT] [$(date "+%Y-%m-%d %H:%M:%S")] $*"
}

if [ -z $1 ]; then
  log "The script can have a parameter. Example: +sv_pure 1 +map ctf_2fort +maxplayers 24, etc..."
  PERMS="+sv_pure 1 +map ctf_2fort +maxplayers 24"
else
  PERMS="$@"
fi

permfix() {
  log "Changing permissions to $UID and $GID..."
  if [ $UID != 1000 ]; then
    sudo groupadd -g $GID $USER
    sudo useradd -m -u $UID -g $GID $USER
    sudo echo $USER' ALL=(ALL:ALL) NOPASSWD:ALL' > sudouser
    sudo echo 'steam ALL=(ALL:ALL) NOPASSWD:ALL' >> sudouser
    sudo cp -v sudouser /etc/sudoers.d
    sudo find $GAME_DIR ! -user $UID -exec sudo chown -R $UID:$GID {} \;
    sudo mv /home/steam/.steam /home/$USER/.steam
    SUDO="sudo -u $USER"
    log "Finished with permissions!"
  else
    USER=steam
    sudo find -D exec $GAME_DIR ! -user steam -exec sudo chown -c -R steam:steam {} \;
  fi
}

#Update function.
update() {
  log "Starting update."
  permfix
  $SUDO $STEAMCMD_BIN +login anonymous +force_install_dir $GAME_DIR +app_update 232250 +quit
  log "Update finished!"
}

sourcemod_flag() {
  if [ "$SOURCEMOD" ]; then
   log "Sourcemod is flagged to be downloaded."
   $SUDO mkdir -p $GAME_DIR/tf/addons
   $SUDO wget https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6490-linux.tar.gz -P $GAME_DIR/tf
   $SUDO tar -C $GAME_DIR/tf -zxvfk $GAME_DIR/tf/sourcemod-1.10.0-git6490-linux.tar.gz
   $SUDO rm $GAME_DIR/tf/sourcemod-1.10.0-git6490-linux.tar.gz
   $SUDO wget https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz -P $GAME_DIR/tf
   $SUDO tar -C $GAME_DIR/tf -zxvfk $GAME_DIR/tf/mmsource-1.10.7-git971-linux.tar.gz
   $SUDO rm $GAME_DIR/tf/mmsource-1.10.7-git971-linux.tar.gz
   log "Sourcemod is finished downloading."
  fi
}


#Main function.
main() {
  log "Starting main function..."
  permfix
  sourcemod_flag
  if [ "$UPDATE" ]; then
    update
  fi
  MSG="Everything looks good! Starting ${USER^^} server with $PERMS"
  log $MSG
}

if [ "$1" == "/bin/bash" ]; then # tunnel into bash incase we need it
  log "Tunneling to /bin/bash!"
  /bin/bash
  exit
fi

if [ -f "$SRCDS_BIN" ]; then
  log "${USER^^} detected! Proceeding with launch."
  main
else
  log "${USER^^} not detected! Starting update."
  update
  main
fi

$SUDO $SRCDS_BIN -console -game tf $@
