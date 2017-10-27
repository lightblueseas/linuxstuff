# aliases
# show all aliases that can be used here or elsewhere
alias a="alias"
# aliasies for source commands
alias loadProfileFile="source ~/.profile; . ~/.profile"
alias lpf="source ~/.profile; . ~/.profile"
# aliasies for bower commands
alias bowerinst="bower install"
alias bowi="bower install"
alias bi="bower install"
alias bowh="bower --help"
alias rmbn="rm -rf bower_components/ node_modules/"
# aliasies for directory commands
alias c="cd ..; pwd"
alias cdd="cd ."
alias ls="ls -al"
alias cdev="cd ~/dev"
alias cdg="cd ~/git"
##
# Create the given directory and change to it
##
mkcd () {
    mkdir -p $1
    cd $1
}
# aliasies for git commands
alias gp="git pull"
alias gfgmdev="git fetch; git merge origin/master --ff-only"
alias gps="git push"
alias listallBranches="git branch -a"
alias lab="git branch -a"
alias listlocalBranches="git branch"
alias llb="git branch"
alias listremoteBranches="git branch -r"
alias lrb="git branch -r"
alias deletelocalbranch="git branch -d"
alias dlb="git branch -d"
alias createnewbranch="git checkout -b"
alias cnb="git checkout -b"
alias gcm="git checkout master"
alias gcd="git checkout develop"
# create an 'empty' branch for the github pages
alias gcghp="git checkout --orphan gh-pages"
####################################
# functions for git commands
##
# Create new git branch
# $1 the name of the new git branch
# $2 the git branch name from where to branch
##
gcnb () {
	git checkout -b $1 $2
}

##
# Create new git branch from master
# $1 the name of the new git branch
##
gcnbm () {
	git checkout -b $1 master
}

##
# Create new git branch from develop
# $1 the name of the new git branch
##
gcnbd () {
	git checkout -b $1 develop
}
# aliasies for gulp commands
alias gpcl="gulp clean"
alias gc="gulp clean"
alias gpbd="gulp build"
alias gb="gulp build"
alias gpse="gulp serve"
# aliasies for mvn commands
alias mvnCleanInstall="mvn clean install -DskipTests=true"
alias mci="mvn clean install -DskipTests=true"
alias mvnCleanPackage="mvn clean package -DskipTests=true"
alias mcp="mvn clean package -DskipTests=true"
alias mvnDependencySources="mvn dependency:sources -DskipTests=true"
alias mds="mvn dependency:sources -DskipTests=true"
alias mvnEclipseCleanEclipse="mvn eclipse:clean eclipse:eclipse -DskipTests=true"
alias mecee="mvn eclipse:clean eclipse:eclipse -DskipTests=true"
alias mvnEclipseEclipseCleanInstall="mvn eclipse:clean eclipse:eclipse clean install -DskipTests=true"
alias meceeci="mvn eclipse:clean eclipse:eclipse clean install -DskipTests=true"
alias mvnDelombokProfile="mvn clean install -Pdelombok-src-with-ant"
alias mcidl="mvn clean install -Pdelombok-src-with-ant"
alias mvnCleanDeployProfile="mvn clean deploy -Poss.sonatype.org-staged-release"
alias mcdps="mvn clean deploy -Poss.sonatype.org-staged-release"
alias mvnFlywayCleanMigrateProfile="mvn flyway:clean flyway:migrate -Para"
alias mfwcm="mvn flyway:clean flyway:migrate -Para"
alias mvnFlywayMigrateProfile="mvn flyway:migrate -Para"
alias mfwm="mvn flyway:migrate -Para"
alias mvnFlywayRepairProfile="mvn flyway:repair -Para"
alias mfwr="mvn flyway:repair -Para"
alias mvnUpdateLicenseHeaderProfile="mvn clean license:format -DskipTests=true -Pupdate-license-header"
alias mulhp="mvn clean license:format -DskipTests=true -Pupdate-license-header"
alias mvnJavadocJavadoc="mvn javadoc:javadoc -DskipTests=true"
alias mjdjd="mvn javadoc:javadoc -DskipTests=true"
alias mvnJavadocJavadocUpdateLicenseHeaderProfile="mvn clean javadoc:javadoc license:format -DskipTests=true -Pupdate-license-header"
alias mvnjdjdulhp="mvn clean javadoc:javadoc license:format -DskipTests=true -Pupdate-license-header"
alias mvnCoberturaCheck="mvn cobertura:check"
alias mcc="mvn cobertura:check"
alias mvnCoberturaCobertura="mvn cobertura:cobertura"
alias mccbrtr="mvn cobertura:cobertura"
alias mvnUpdateChildModules="mvn -N versions:update-child-modules -DskipTests=true"
alias mucm="mvn -N versions:update-child-modules -DskipTests=true"
alias mvnPrepareIzpackProfile="mvn clean install antrun:run -DskipTests=true -Pprepare-and-release-and-izpack"
alias mpip="mvn clean install antrun:run -DskipTests=true -Pprepare-and-release-and-izpack"
alias mvnPrepareResourcesProfile="mvn clean install antrun:run -DskipTests=true -Pprepare-release-resources"
alias mppp="mvn clean install antrun:run -DskipTests=true -Pprepare-release-resources"
# aliasies for npm commands
alias npminst="npm install"
alias npmi="npm install"
alias ni="npm install"
alias npmit="npm init"

##
# Clean and build a node project
##
cleanAndBuildNode () {
	echo '$ git pull'
	git pull
	echo '$ rm -rf bower_components/ node_modules/'
	rm -rf bower_components/ node_modules/
	echo '$ bower install'
	bower install
	echo '$ npm install'
	npm install
	echo '$ gulp clean'
	gulp clean
	echo '$ gulp build'
	gulp build
}
##
# clean up the ubuntu system
##
cleanup() {
   sudo apt-get autoclean
   sudo apt-get clean
   sudo apt-get autoremove
}

##
# Create a tar file that will be encrypted with openssl and the cipher type aes-256-cbc
# $1 the name of the folder to tar and encrypt
# $2 the name of the output file ie. the desired result tar file
##
zipAndEncrypt() {
	tar cz $1 | openssl enc -aes-256-cbc -e > $2
}

##
# Create a tar file that will be encrypted with openssl and the given cipher type
# $1 the name of the folder to tar and encrypt
# $2 the name of the the cipher type
# $3 the name of the the output file ie. the desired result tar file
##
zipAndEncryptWithCipher() {
	tar cz $1 | openssl enc $2 -e > $3
}

##
# Unzip and decrypt the given tar file that is encrypted with openssl and the cipher type aes-256-cbc
# to the current directory. 
# $1 the name of the tar file to decrypt and unzip
##
unzipAndDencrypt() {
	openssl enc -aes-256-cbc -d -in $1 | tar xz
}

##
# Unzip and decrypt the given tar file that is encrypted with openssl and the cipher type aes-256-cbc
# to the specified directory.
# $1 the name of the tar file to decrypt and unzip
# $2 the directory to unzip the given tar file 
##
unzipAndDencryptWithCipher() {
	openssl enc -aes-256-cbc -d -in $1 | tar xz --directory $2
}

##
# Unzip and decrypt the given tar file that is encrypted with openssl and the cipher type
# to the specified directory.
# $1 the name of the tar file to decrypt and unzip
# $2 the name of the the cipher type
# $3 the directory to unzip the given tar file 
##
unzipAndDencryptWithCipher() {
	openssl enc $2 -d -in $1 | tar xz --directory $3
}
