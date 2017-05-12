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
		# if yes change to it and pull
		echo -e "Directory $localRepoDir exits, change to it ...\n"
		pullCmd="git pull" 
		echo -e "Running pull command: $pullCmd \n"
		cd $gitRepositoryName 
		git checkout develop		
		git pull
		cd ..	
	else 
				
	fi
done