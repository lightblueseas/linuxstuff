#!/usr/bin/env bash
sudo apt install zsh
zsh --version
chsh -s $(which zsh)
echo $SHELL
