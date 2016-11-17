# This are some aliases for commands i use often
#
# aliases
# show all aliases that can be used here or elsewhere
alias a="alias"
# aliasies for mvn commands
alias mci="mvn clean install -DskipTests=true"
# aliasies for directory commands
alias c="cd ..; pwd"
alias ls="ls -al"
alias rmbn="rm -rf bower_components/ node_modules/"
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
# aliasies for source commands
alias loadProfileFile="source ~/.profile; . ~/.profile"
alias lpf="source ~/.profile; . ~/.profile"
# aliasies for npm commands
alias npminst="npm install"
alias npmi="npm install"
alias ni="npm install"
alias bi="bower install"
alias npmit="npm init"
# aliasies for bower commands
alias bowerinst="bower install"
alias bowi="bower install"
alias bowh="bower --help"
# aliasies for gulp commands
alias gpcl="gulp clean"
alias gc="gulp clean"
alias gpbd="gulp build"
alias gb="gulp build"
alias gpse="gulp serve"
# functions
##
# Create the given directory and change to it
##
mkcd () {
    mkdir -p $1
    cd $1
}

##
# Clean and build a node project
##
cleanAndBuildNode () {
	rm -rf bower_components/ node_modules/
	bower install
	npm install
	gulp clean
	gulp build
}
