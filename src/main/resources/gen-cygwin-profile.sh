#!/bin/bash
# merge defragmented aliases files to the '.cygwinprofile'. 
# This file can than merged with the '.profile' for the cygwin home directory.
cat .bashhistory .cygwindir .git-aliases .mvnrc .zipping > .cygwinprofile