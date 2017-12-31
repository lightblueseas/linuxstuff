##
# clean up the ubuntu system
##
cleanup() {
   sudo apt-get autoclean
   sudo apt-get clean
   sudo apt-get autoremove
   sudo apt-get upgrade
}
