#!/bin/zsh
# import remote git repositories to local git dir

# Echoes all commands before executing.
set -o verbose
# settings 
remoteGithubHost=github.com
remoteOrgUser=astrapi69
localCodeDir="${HOME}/git/"
githubRepositoryNames=(
"jgeohash"
"jaulp.wicket"
"mystic-crypt"
"resourcebundle-core"
"turbo-ninja"
"jetty-runner"
"wicket.component.authorization.strategy"
"wicket-angular-js"
"redundant-file-entries-resolver"
"wicket-examples"
"jquery-dropdowntrigger"
"c10n.interface.generator")

cd $localCodeDir
pwd
for gitRepo in $githubRepositoryNames

do
  localRepoDir=$(echo ${localCodeDir}${gitRepo}|cut -d'.' -f1)

   if [[ -d $localRepoDir ]]; then 
		echo -e "Directory $localRepoDir already exits, skipping ...\n"
	else   
		echo -e "Directory $localRepoDir does not exits, start clone repository ...\n"
		echo -e "Running clone command: $cloneCmd \n"
		git clone https://$remoteGithubHost/$remoteOrgUser/$gitRepo.git
		cd $gitRepo 
		git checkout develop
		cd $localCodeDir
		
  fi
done