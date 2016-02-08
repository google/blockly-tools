#!/bin/bash

# Initialization script for setting up the dev environment for Blockly.
# This will set up the bgit command as well.
#
# To run use "source tools/envsetup.sh"

if [ ! -d ".repo" ]; then
  echo "Must call from the root repo directory!"
  return
fi

export BLOCKLY_ROOT="$(pwd)"

if [ "$BLOCKLY_USER" = "" ]; then
  while true; do
    read -p "GitHub username:" user
    if [ "$user" == "" ]; then
      echo "Username may not be empty"
    else
      echo "Set your username to $user."
      export BLOCKLY_USER=$user
      break
    fi
  done
else
  echo "Username is $BLOCKLY_USER. To update, use 'export BLOCKLY_USER=<new user>'."
fi
export BLOCKLY_INIT=true

export PATH="$PATH:$BLOCKLY_ROOT/tools"

# Enables rerere recording of merge resolutions
git config --global rerere.enabled true
