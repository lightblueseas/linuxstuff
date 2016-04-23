# linuxstuff

# initial install of ubuntu os with usefull tools for development

### Install clip it. You do that with the following command:

```shell
sudo apt-get update && sudo apt-get install clipit
```

### Install zsh: You do that with the following command:
```shell
sudo apt install zsh
```
+ Verify that zsh is installed:
```shell
zsh --version
```
+ Set zsh as your default shell.
```shell
chsh -s $(which zsh)
```
+ Verify that zsh set as your default shell. 
```shell
echo $SHELL
```
if this gives /bin/bash out than you have to log out from ubuntu or reboot and login again. Than verify again that zsh is set as your default shell. 
```shell
echo $SHELL
```
this should be the output: 
/usr/bin/zsh

A similar install description of zsh is on this link https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH.

### Install git
```shell
sudo apt-get install git
```
+ 

### Install of Oh-My-Zsh

This description is the same as on the github page of Oh-My-Zsh.

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```




