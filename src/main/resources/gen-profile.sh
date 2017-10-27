#!/bin/bash
# merge defragmented aliases files to the '.profile'. 
# This file can than merged with the '.profile' for the users home directory.
cat .aliasesrc .bowerrc .dirrc .git-aliases .gulprc .mvnrc .npmrc .tweak.sh .zipping > .profile