#!/bin/bash
# import multiple remote git repositories to local git dir

# Echoes all commands before executing.
set -o verbose
# settings 
remoteGithubHost=$0 # this is the remote host i.e.:github.com
remoteSingleUser=$1 # the username of the remote host
remoteOrgUser=$2 # the organisation name
remoteDir="~/repositories/"
remoteRepos=$(ssh -l $remoteUser $remoteHost "ls $remoteDir")
localCodeDir="${HOME}/git/"

# if no output from the remote ssh cmd, bail out
if [ -z "$remoteRepos" ]; then
    echo "No results from remote repo listing (via SSH)"
    exit
fi

# for each repo found remotely, check if it exists locally
# assumption: name repo = repo.git, to be saved to repo (w/o .git)
# if dir exists, skip, if not, clone the remote git repo into it
for gitRepo in $remoteRepos
do
  localRepoDir=$(echo ${localCodeDir}${gitRepo}|cut -d'.' -f1)
  if [ -d $localRepoDir ]; then 	
		echo -e "Directory $localRepoDir already exits, skipping ...\n"
	else
		cloneCmd="git clone https://$remoteUser@$remoteHost/$remoteDir"		
		
		cloneCmdRun=$($cloneCmd)

		echo -e "Running: \n$ $cloneCmd"
		echo -e "${cloneCmdRun}\n\n"
	fi
done