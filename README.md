# linuxstuff

# initial install of ubuntu os with usefull tools for development

* Install clip it. You do that with the following command:

```bash
sudo apt-get update && sudo apt-get install clipit
```

* Install zsh: You do that with the following command:
```bash
sudo apt install zsh
```
+ Verify that zsh is installed:
```bash
zsh --version
```
+ Set zsh as your default shell.
```bash
chsh -s $(which zsh)
```
2.3 Verify that zsh set as your default shell. 
```bash
echo $SHELL
```
if this gives /bin/bash out than you have to log out from ubuntu or reboot and login again. Than verify again that zsh is set as your default shell. 
```bash
echo $SHELL
```
this should be the output: 
/usr/bin/zsh

A similar install description is of zsh is on this link https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH.

3. Install now Oh-My-Zsh. 


