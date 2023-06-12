#!/bin/sh

# find download url
download_url=$(curl --silent https://api.github.com/repos/it-solutions-dev/device-bin/releases/latest | grep '"browser_download_url"' | grep .deb | grep -Eo 'https://[^ >]+\w' | head -1)

echo "Downloading $download_url"

# download
wget $download_url

# get file name and install it
file_name=$(ls | grep fliko-device)
sudo apt install ./$file_name

# remove downloaded file
rm $file_name

# find install folder and change permissions
install_folder=$(find /usr/lib -name fliko-device)

# check if folder exists
if [ -z "$install_folder" ]
then
      echo "Folder not found, install script failed"
      exit 1
fi

# change permissions
echo "Changing permissions for $install_folder"
sudo chmod -R 777 $install_folder

echo "Installed successfully"

# add auto startup
echo "Adding auto startup"
