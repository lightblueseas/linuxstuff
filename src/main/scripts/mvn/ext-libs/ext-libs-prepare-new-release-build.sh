#!/bin/bash
# import settings for the ext-lib projects for building.
# import variables from file.
source ext-libs-settings.sh

# Echoes all commands before executing.
set -o verbose

# change to git directory
cd $localCodeDir
pwd
# iterate over the repository names
for projectName in $projectNames

do
	# create a string from the local project directory for checks
	localProjectDir=$(echo ${localCodeDir}${projectName})
	# check if the local repository directory already exists
	if [[ -d $localProjectDir ]]; then 
		# if yes execute mvn command
		cd $projectName
		mvn -Pupdate-license-header -B --threads 8 clean license:format
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 javadoc:javadoc
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
		cd $localCodeDir			
	else 
		# if not then clone it and check out the develop branch  
		echo -e "Directory $localProjectDir does not exits, start clone repository ...\n"
		echo -e "Running clone command: $cloneCmd \n"
		# git clone 
		git clone https://$remoteUser@$remoteHost/$remoteUser/$projectName.git
		cd $projectName 
		git checkout develop
		mvn -Pupdate-license-header -B --threads 8 clean license:format
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 javadoc:javadoc
		mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
		cd $localCodeDir			
	fi
done
