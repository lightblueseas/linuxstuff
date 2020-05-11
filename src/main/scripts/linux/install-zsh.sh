#!/usr/bin/env bash
sudo apt -y install zsh
zsh --version
chsh -s $(which zsh)
echo $SHELL
