#!/bin/bash
# import settings for the ext-lib projects for building.
# import variables from file.
source ext-libs-settings.sh

# Echoes all commands before executing.
set -o verbose

# change to git directory
cd $localCodeDir
pwd
# iterate over the repository names
for projectName in $projectNames
# TODO 