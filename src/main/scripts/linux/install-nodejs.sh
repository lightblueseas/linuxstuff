#!/usr/bin/env bash
# nodejs
sudo apt-get install nodejs 
sudo apt-get install npm
DIR="/usr/local/lib/node_modules"
if [ -d "$DIR" ]; then
  # create node modules directory #
  sudo mkdir $DIR
fi
# change owner of node modules directory to the current user
sudo chown -R $USER $DIR
