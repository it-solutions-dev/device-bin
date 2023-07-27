#!/bin/bash

# check if kiosk dir exists
root_dir=~/kiosk/fliko-device

if [ ! -d $root_dir ]
then
      echo "Creating kiosk folder"
      mkdir -p $root_dir/current
      touch $root_dir/latest.json
      touch $root_dir/version.txt
else 
      echo "$root_dir already exists use update script or remove before isntalling"
      exit 1
fi

# download latest json 
latest_file=$root_dir/latest.json
version_file=$root_dir/version.txt
curl --silent https://api.github.com/repos/it-solutions-dev/device-bin/releases/latest > $latest_file

# extract download and version number
version=$(cat $latest_file | grep '"tag_name"' | grep -Eo '[0-9]+.[0-9]+.[0-9]+')
download_url=$(cat $latest_file | grep '"browser_download_url"' | grep -Eo 'https://[^ >]+\w' | grep '.zip$')

echo "Latest version is $version"
echo "Downloading $download_url"

# downlaod
wget $download_url -P $root_dir

# change context location to root_dir
cd $root_dir

zip_file_name=$(ls | grep fliko-device)

# rename zip file to fd.zip
mv $zip_file_name fd.zip
zip_file_name=fd.zip

echo "Unzipping $zip_file_name" 

# unzip in root_dir
unzip -o -q $zip_file_name -d $root_dir
unziped_folder=$(ls -d */ | grep fliko-device)

#rename $unziped_folder to version number
mv $root_dir/$unziped_folder $root_dir/$version

# remove downloaded file
rm $zip_file_name

# create symlink from fliko-device-linux-x64 to /current
ln -nfs $root_dir/$version/* $root_dir/current

#publish path to bashrc
echo 'Adding /kiosk/fliko-device/current to PATH'
echo "export PATH=$PATH:$root_dir/current" >> ~/.bashrc

# restart bash
source ~/.bashrc

