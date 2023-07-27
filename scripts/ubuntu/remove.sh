#!/bin/bash

# find install folder fliko-device
root_dir=~/kiosk/fliko-device

# check if folder exists
if [ ! -d $root_dir ]
then
      echo "App not installed"
      exit 1
fi

# remove app
rm -rf $root_dir

# remove sed -i ~/kiosk/fliko-device/current from $PATH
sed -i '/kiosk\/fliko-device\/current/d' ~/.bashrc

# restart bash
source ~/.bashrc

echo "Fliko device app removed"