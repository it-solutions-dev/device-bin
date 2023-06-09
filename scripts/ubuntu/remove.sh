#!/bin/sh

# find install folder fliko-device
lib_folder=$(find /usr/lib -name fliko-device)

# check if folder exists
if [ -z "$lib_folder" ]
then
      echo "Folder not found"
      exit 1
fi

# remove app
sudo apt remove fliko-device

# remove install folder
sudo rm -rf $lib_folder



# sed url from stream: browser_download_url": "https://github.com/it-solutions-dev/device-bin/releases/download/v0.3.2/fliko-device_0.3.2_amd64.deb"




