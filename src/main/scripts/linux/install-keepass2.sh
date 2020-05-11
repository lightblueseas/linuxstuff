#!/usr/bin/env bash
sudo add-apt-repository ppa:jtaylor/keepass
sudo apt-get update
sudo apt-get install -y keepass2
sudo apt-get install -y ppa-purge && sudo ppa-purge ppa:jtaylor/keepass