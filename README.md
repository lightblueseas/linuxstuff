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

A better install description of zsh is on this link https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH.

### Install git
```shell
sudo apt-get install git
```
Create the git directory and change to it. 
```shell
mkdir ~/git && cd git
```

### Install of Oh-My-Zsh

You can now install Oh-My-Zsh with the command-line either `curl` or `wget`.

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

A better install description of Oh-My-Zsh is on this link [github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)


### Install java jdk

For install the java jdk you have to add a repository. This is the ppa:webupd8team/java. You do that with the following command:

```shell
sudo add-apt-repository ppa:webupd8team/java
```

Then you have to update first and the install the jdk:
```shell
sudo apt-get update
sudo apt-get install oracle-java8-installer
```
A better install description of install jdk on ubuntu is on this link [webupd8.org](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)

### Create default directories 

Now you can create directories for useful IDE's.  You do that with the following command:
```shell
mkdir ~/ides && mkdir ~/ides/eclipse && mkdir ~/ides/netbeans && mkdir ~/ides/jedit && mkdir ~/ides/androidstudios
```
