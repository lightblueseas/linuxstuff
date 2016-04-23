# linuxstuff

# initial install of ubuntu os with usefull tools for development

1. install clip it. You do that with the following command:

sudo apt-get update && sudo apt-get install clipit

2. install zsh: You do that with the following command:

sudo apt install zsh

2.1 Verify that zsh is installed:

zsh --version

2.2 Zsh set as your default shell. 

echo $SHELL

if this gives /bin/bash out than you have to seht zsh to the default shell with this command:

chsh -s $(which zsh)

