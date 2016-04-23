# linuxstuff

# initial install of ubuntu os with usefull tools for development

1. install clip it. You do that with the following command:

sudo apt-get update && sudo apt-get install clipit

2. install zsh: You do that with the following command:

sudo apt install zsh

2.1 Verify that zsh is installed:

zsh --version

2.2 Set zsh as your default shell.

chsh -s $(which zsh)

2.3 Verify that zsh set as your default shell. 

echo $SHELL

if this gives /bin/bash out than you have to log out from ubuntu or reboot and login again. Than verify again that zsh is set as your default shell. 

echo $SHELL

this should be the output: 
/usr/bin/zsh

3. Install now Oh-My-Zsh. For this see first the recommended version on homepage https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH.


