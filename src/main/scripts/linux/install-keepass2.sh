#!/usr/bin/env bash
sudo add-apt-repository ppa:jtaylor/keepass
sudo apt-get update
sudo apt-get install keepass2
sudo apt-get install ppa-purge && sudo ppa-purge ppa:jtaylor/keepass