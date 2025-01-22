#!/bin/bash


# Define the repository path
repo_path="/home/breynald/StatusCheck"

# Change to the repository directory
cd $repo_path

# Add the status_log.json file to the staging area
git add status_log.json

# Commit the changes with a message
git commit -m "Update status_log.json"

# Push the changes to the remote repository
git push origin main
