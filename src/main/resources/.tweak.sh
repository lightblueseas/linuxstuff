##
# clean up the ubuntu system
##
cleanup() {
   sudo apt-get autoclean
   sudo apt-get clean
   sudo apt-get autoremove
   sudo apt-get update
   sudo apt-get upgrade
   sudo apt --fix-broken install
   rm -rf ~/.cache/thumbnails/*
}
