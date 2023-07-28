#!/bin/bash

# kill any running fliko-device process
# collect fkijo-device process ids and check if there is any

processes=$(ps -ef | grep fliko-device | grep -v grep)

if [ -z "$processes" ]
then
      echo "No fliko-device processes running"
else
      echo "Killing fliko-device processes"
      echo "$processes" | awk '{print $2}' | xargs kill -9
fi


update_script=~/kiosk/update.sh

# check if update script exists 
if [ -e $update_script ]
then
    echo "Running update script"
    bash $update_script
else
    echo "Update script not found"
fi



# start fliko-device
~/kiosk/fliko-device/current/fliko-device

