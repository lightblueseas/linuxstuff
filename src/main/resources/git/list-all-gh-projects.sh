#!/bin/zsh
# export all public remote git repositories from the given user to given file path with file name
echo 'Insert your github username:'
read USER 
echo 'Insert the file name to export the remote git repositories from the given user:'
read TO_FILE
curl -s "https://api.github.com/users/$USER/repos?per_page=1000" | grep -o 'git@[^"]*'| cut -d'/' -f2 > $TO_FILE