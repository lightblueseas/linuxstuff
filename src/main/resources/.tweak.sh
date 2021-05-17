##############################
# clean up the ubuntu system #
##############################
cleanup() {
   sudo apt-get autoclean
   sudo apt-get clean
   sudo apt-get autoremove
   sudo apt-get update
   sudo apt-get upgrade
   sudo apt --fix-broken install
}

##########################################
# clean up the thumbnails from the cache #
##########################################
cleanupThumbnails() {
   rm -rf ~/.cache/thumbnails/*
}
