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

A detailed install description of zsh is on this link https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH.

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

A detailed install description of Oh-My-Zsh is on this link [github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)


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
A detailed install description of install jdk on ubuntu is on this link [webupd8.org](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)

### Create default directories 

Now you can create directories for useful IDE's. You do that with the following command:
```shell
mkdir ~/ides && mkdir ~/ides/eclipse && mkdir ~/ides/netbeans && mkdir ~/ides/jedit && mkdir ~/ides/androidstudios
```

Create directories for workspaces(wss), tmp, apps and development(dev). You do that with the following command:
```shell
mkdir ~/wss && mkdir ~/dev  && mkdir ~/dev/servers && mkdir ~/tmp && mkdir ~/apps
```
### Install Ubuntu Tweak

For install the Ubuntu Tweak you have to add a repository. This is the ppa:tualatrix/ppa. You do that with the following command:

```shell
sudo add-apt-repository ppa:tualatrix/ppa
```

Then you have to update first and the install the Ubuntu Tweak:
```shell
sudo apt-get update
sudo apt-get install ubuntu-tweak
```
A detailed install description(in german) of install Ubuntu Tweak on ubuntu is on this link [https://wiki.ubuntuusers.de/Ubuntu_Tweak/](https://wiki.ubuntuusers.de/Ubuntu_Tweak/)

## Install IDE's

### Install jedit

To install jedit download the java installer from jedit.org. The link for version 5.3.0 is [http://sourceforge.net/projects/jedit/files/jedit/5.3.0/jedit5.3.0install.jar/download](http://sourceforge.net/projects/jedit/files/jedit/5.3.0/jedit5.3.0install.jar/download)

For install plugins DO NOT USE the integrated plugin manager. I downloaded once from the plugin manager and many plugins does not load. So download every plugin that you really need manually.

### Install netbeans

For install netbeans you have to download the os indipendent zip file. Than you can install it to the appropriate directory ~/ides/netbeans/ and any servers(like glassfish or tomcat) to the the appropriate directory ~/dev/servers

