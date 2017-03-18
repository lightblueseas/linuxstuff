#!/bin/zsh
# import remote git repositories to local git dir

# import variables from file.
source impgitrep-settings.sh

# Echoes all commands before executing.
set -o verbose

# change to git directory
cd $localCodeDir
pwd
# iterate over the repository names
for gitRepositoryName in $gitRepositoryNames

do
	# create a string from the local repository directory for checks
	localRepoDir=$(echo ${localCodeDir}${gitRepositoryName}|cut -d'.' -f1)
	# check if the local repository directory already exists
	if [[ -d $localRepoDir ]]; then 
		# if yes skip and continue the iteration
		echo -e "Directory $localRepoDir already exits, skipping ...\n"
	else 
		cloneCmd="git clone https://$remoteUser@$remoteHost/$remoteDir/$projectName.git"
		# if not then clone it and check out the develop branch  
		echo -e "Directory $localRepoDir does not exits, start clone repository ...\n"
		echo -e "Running clone command: $cloneCmd \n"
		git clone https://$remoteHost/$remoteUser/$gitRepositoryName.git
		cd $gitRepositoryName 
		git checkout develop
		cd $localCodeDir			
	fi
done