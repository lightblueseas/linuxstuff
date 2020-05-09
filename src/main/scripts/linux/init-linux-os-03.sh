sudo apt-get install gnupg-agent pinentry-gtk2
sudo apt-get install ktouch
sudo apt-get install shotwell
sudo apt-get install gnome-system-tools
sudo apt-get install gnome-sushi 
# nautilus extensions
sudo apt-get install nautilus-actions
sudo apt-get install nautilus-gksu
sudo apt-get install nautilus-actions-extra
sudo apt-get install nautilus-admin 
sudo apt-get install nautilus-sendto 
sudo apt-get install nautilus-image-converter 
sudo apt-get install nautilus-compare 
sudo apt-get install nautilus-wipe 
sudo apt-get install seahorse-nautilus 
sudo apt-get install nautilus-gtkhash 
sudo apt-get install nautilus-share
sudo apt-get install nautilus-script-manager
sudo apt-get install ffmpegthumbnailer 
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
