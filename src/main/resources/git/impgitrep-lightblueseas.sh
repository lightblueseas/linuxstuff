#!/bin/zsh
# import remote git repositories to local git dir

# Echoes all commands before executing.
set -o verbose
# settings 
remoteGithubHost=github.com
remoteOrgUser=lightblueseas
localCodeDir="${HOME}/git/"
githubRepositoryNames=(
"address-book-data"
"backpain"
"bootstrap"
"cashbox-server"
"chat-systems"
"dating-system-data"
"design-patterns"
"email-tails"
"event-system-data"
"file-worker"
"freelancerdocs"
"gen-tree"
"jcommons-lang"
"jfugue-core"
"jrunalyzer"
"jsontoken"
"knockout-doc-examples"
"linuxstuff"
"message-system-data"
"mvn-java-parent"
"mvn-less-css"
"mvn-parent-projects"
"mvn-persistence-parent"
"mvn-ui-parent"
"mvn-wicket-application-parent"
"mvn-wicket-parent"
"net-extensions"
"object-model"
"order-management-data"
"payment-system-data"
"persistence-api"
"phone-data-management-system"
"purifycss"
"rating-system-data"
"resource-bundles-data"
"resource-system-data"
"scheduler-system-data"
"secured-bundle-application-data"
"server-configurations"
"silly-collections"
"swing-components"
"system-hook"
"test-objects"
"user-data"
"user-management-data"
"vintage-time"
"Virtual-Piano"
"wapiti"
"wicket-application"
"wicket-application-template"
"wicket-js-addons"
"xml-extensions"
)

cd $localCodeDir
pwd
for gitRepo in $githubRepositoryNames

do
  localRepoDir=$(echo ${localCodeDir}${gitRepo}|cut -d'.' -f1)

   if [[ -d $localRepoDir ]]; then 
		echo -e "Directory $localRepoDir already exits, skipping ...\n"
	else   
		cloneCmd="git clone https://$remoteUser@$remoteHost/$remoteDir/$projectName.git"
		echo -e "Directory $localRepoDir does not exits, start clone repository ...\n"
		echo -e "Running clone command: $cloneCmd \n"
		git clone https://$remoteGithubHost/$remoteOrgUser/$gitRepo.git
		cd $gitRepo 
		git checkout develop
		cd $localCodeDir
		
  fi
done