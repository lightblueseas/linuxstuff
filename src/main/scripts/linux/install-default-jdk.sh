#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade
sudo apt install -y default-jdk
java -version
sudo apt-get install -y maven
echo $JAVA_HOME
sudo awk 'BEGIN{ printf "JAVA_HOME=\"/usr/lib/jvm/default-java\"" >> "/etc/environment"  }'
source /etc/environment
echo $JAVA_HOME
sudo apt-get install -y jedit