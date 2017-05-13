#!/bin/zsh
# import remote git repositories to local git dir

# Echoes all commands before executing.
set -o verbose
# settings 
remoteGithubHost=github.com
remoteOrgUser=astrapi69
localCodeDir="${HOME}/git/"
githubRepositoryNames=(
"angular-pnotify"
"angular-seed"
"antilia-bits"
"atom-hopper"
"blogs"
"bootstrap-session-timeout"
"bundle-manager"
"c10n"
"c10n.interface.generator"
"chap-links-library"
"core"
"delombok-template"
"distributions"
"DroidBallet"
"fiftyfive-wicket"
"flexdock"
"foolish.js"
"gantt-wicket"
"GeoIP"
"globalo-client"
"HibernateGenericDao"
"jaulp-wicket"
"jetty-runner"
"jgeohash"
"jquery-dropdowntrigger"
"jquery.ganttView"
"knockout.extensions"
"ko-custom-bindings"
"maven-formatter-plugin"
"menu-card"
"mithril"
"mystic-crypt"
"mystic-crypt-ui"
"npm-singin-module"
"nv-i18n"
"pf4j"
"phantomjs"
"planning-poker"
"portal"
"puree-android"
"redundant-file-entries-resolver"
"resourcebundle-core"
"runtime-compiler"
"scrypt"
"servlet3-chat"
"ServletIO"
"spring.hibernate.jpa"
"swagger-codegen"
"threedlite"
"torpedoquery"
"turbo-ninja"
"turbo-sansa"
"unirest-java"
"visural-wicket"
"wicket"
"wicket-angular-js"
"wicket-bootstrap"
"wicket-chat"
"wicket-cometd2"
"wicket-commons"
"wicket-console"
"wicket-examples"
"wicket-foundation"
"wicket-googlevis"
"wicket-jquery-ui"
"wicket-metrics"
"wicket-source"
"wicket.component.authorization.strategy"
"WicketExperiments"
"wiquery"
"xaloon"
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