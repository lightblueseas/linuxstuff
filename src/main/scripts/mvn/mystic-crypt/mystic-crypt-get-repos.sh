#!/bin/bash
#
# This script gets all projects and change to the develop branch makes a git pull
# and builds. If the project is not on local disk it get it from the remote host.
# 

# import settings for the ext-lib projects for building.
# import variables from file.
source mystic-crypt-settings.sh

# Echoes all commands before executing.
set -o verbose

# change to git directory
cd $localCodeDir
pwd
# iterate over the repository names
for projectName in $projectNames

do
	# create a string from the local project directory for checks
	# will be displayed in console and is irritating i know...
	localProjectDir=$(echo ${localCodeDir}${projectName}) 
	echo -e "var: $localProjectDir is the current project directory ...\n"
	# check if the local repository directory already exists
	if [[ -d $localProjectDir ]]; then 
		# if yes execute mvn command
		cd $projectName
		git checkout develop
		git pull
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
		cd $localCodeDir			
	else 		
		cloneCmd="git clone https://$remoteUser@$remoteHost/$remoteDir/$projectName.git"
		# if not then clone it and check out the develop branch  
		echo -e "Directory $localProjectDir does not exits, start clone repository ...\n"
		echo -e "Running clone command: $cloneCmd \n"
		# git clone 
		git clone https://$remoteUser@$remoteHost/$remoteUser/$projectName.git
		cd $projectName 
		git checkout develop
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
		cd $localCodeDir			
	fi
done
