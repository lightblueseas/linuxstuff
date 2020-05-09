sudo apt-get install gnupg-agent 
sudo apt-get install pinentry-gtk2
sudo apt-get install ktouch
sudo apt-get install shotwell
sudo apt-get install gnome-system-tools
sudo apt-get install gnome-sushi 
# nautilus extensions
./install-nautilus-extensions.sh
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
# antivirus programm clamav
./install-antivirus-clamav.sh
# python3-pip
sudo apt-get install python3-pip
# music player
sudo apt-get install audacious audacious-plugins
# for canberra
sudo apt-get install libcanberra-gtk-module 
sudo apt-get install libcanberra-gtk3-module
