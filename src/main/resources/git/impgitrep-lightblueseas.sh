#!/bin/zsh
# import remote git repositories to local git dir

# Echoes all commands before executing.
set -o verbose
# settings 
remoteGithubHost=github.com
remoteOrgUser=lightblueseas
localCodeDir="${HOME}/git/"
githubRepositoryNames=(
"jfugue-core" 
"mvn-parent-projects" 
"linuxstuff" 
"knockout-doc-examples" 
"payment-system-data" 
"order-management-data" 
"user-management-data"
"file-worker"
"swing-components"
"silly-collections"
"email-tails"
"gen-tree"
"jcommons-lang"
"net-extensions"
"test-objects"
"vintage-time"
"xml-extensions"
"resource-system-data"
"address-book-data"
"resource-bundles-data"
"message-system-data"
"phone-data-management-system"
"scheduler-system-data"
"dating-system-data"
"event-system-data"
"rating-system-data"
"persistence-api"
"server-configurations"
"wicket-js-addons"
"mvn-less-css"
"design-patterns"
"wicket-application-template"
"freelancerdocs"
"sitedocs")

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