sudo apt-get install gnupg-agent pinentry-gtk2
sudo apt-get install ktouch
sudo apt-get install shotwell
sudo apt-get install gnome-system-tools
sudo apt-get install gnome-sushi 
# nautilus extensions
./install-nautilus-extensions.sh
# nodejs
sudo apt install nodejs npm
DIR="/usr/local/lib/node_modules"
if [ -d "$DIR" ]; then
  # create node modules directory #
  sudo mkdir $DIR
fi
# change owner of node modules directory to the current user
sudo chown -R $USER $DIR
# antivirus programm clamav
sudo apt-get install clamav clamav-freshclam 
sudo apt-get install clamav-docs
sudo apt-get install clamav-daemon 
sudo apt-get install clamtk 
sudo apt-get install clamtk-nautilus
sudo apt-get install python3-pip
# music player
sudo apt-get install audacious audacious-plugins
# for canberra
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module
