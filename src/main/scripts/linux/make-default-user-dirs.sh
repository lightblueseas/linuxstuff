#!/bin/bash

# Define an array of directories to be created
directories=(
    "$HOME/dev"
    "$HOME/dev/app"
    "$HOME/dev/data"
    "$HOME/dev/doc"
    "$HOME/dev/git"
    "$HOME/dev/git/hub"
    "$HOME/dev/git/lab"
    "$HOME/dev/sec"
    "$HOME/dev/sec/db"
    "$HOME/dev/sec/keystore"
    "$HOME/dev/sec/kleidi"
    "$HOME/dev/server"
    "$HOME/dev/temp"
    "$HOME/dev/test"
    "$HOME/dev/test/data"
    "$HOME/dev/tmp"
    "$HOME/dev/wss"
    "$HOME/dev/ide"
    "$HOME/dev/ide/eclipse"
    "$HOME/dev/ide/netbeans"
    "$HOME/dev/ide/jedit"
    "$HOME/dev/ide/androidstudio"
    "$HOME/dev/ide/idea"
)

# Create directories if they do not exist
for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created: $dir"
    else
        echo "Already exists: $dir"
    fi
done

echo "All directories have been created successfully."
