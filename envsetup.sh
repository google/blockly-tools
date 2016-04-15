#!/bin/bash

# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
