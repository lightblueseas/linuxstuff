sudo apt-get install git
sudo apt-get install curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade
sudo apt install default-jdk
java -version
sudo apt-get install maven
echo $JAVA_HOME
sudo awk 'BEGIN{ printf "JAVA_HOME=\"/usr/lib/jvm/java-8-oracle\"" >> "/etc/environment"  }'
sudo echo "JAVA_HOME=/usr/lib/jvm/default-java" >> /etc/environment
sudo source /etc/environment
echo $JAVA_HOME
sudo apt-get install jedit
cd ~
mkdir ides && mkdir ~/ides/eclipse && mkdir ~/ides/netbeans && mkdir ~/ides/jedit && mkdir ~/ides/androidstudios
mkdir ~/wss && mkdir ~/dev  && mkdir ~/dev/servers && mkdir ~/tmp && mkdir ~/apps
sudo apt-get install chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
sudo apt-get install chromium-codecs-ffmpeg-extra
sudo add-apt-repository ppa:jtaylor/keepass
sudo apt-get update
sudo apt-get install keepass2
