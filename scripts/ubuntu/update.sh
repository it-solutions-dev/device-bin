#!/bin/bash

function version
{
      echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; 
}

function format_json_file() 
{
      jq . $1 > $1.tmp && mv $1.tmp $1
}

# Url passed to script

latest_api_url=$(echo $1)
root_dir=~/kiosk/fliko-device
cache_dir=./cache
latest_json_file=$cache_dir/latest.json


# check if root_dir or version file exists
# check if version file exists

if [ ! -d $root_dir ] || [ ! -f $root_dir/version.txt ]
then
      echo "App installed incorrectlly run remove or install scripts first"
      exit 1
fi

echo "Checking for $latest_json_file file"

if [ ! -f $latest_json_file ]
then
      echo "Creating latest.json file"
      touch $latest_json_file
fi

curl -s -o $latest_json_file $latest_api_url

# making sure that json file formatted for grep
format_json_file $latest_json_file 

current_version=$(cat $root_dir/version.txt)
remote_version=$(cat $latest_json_file | grep '"version"' | grep -Eo '[0-9]+.[0-9]+.[0-9]+')

# compare versions
if [ $(version $current_version) -ge $(version $remote_version) ]
then
      echo "Current version is $current_version"
      echo "Remote version is $remote_version"
      exit 0
fi

if [ $(systemctl is-active --user kiosk.service) == 'active' ]
then
      echo "Stopping kiosk.service"
      systemctl stop --user kiosk.service
      systemctl start --user kiosk-update.service
fi

# find download url
download_url=$(cat $latest_json_file | grep '"download_url"' | grep .zip | grep -Eo 'https://[^ >]+\w' | head -1)

echo "Downloading $download_url"
wget $download_url -P $root_dir

# check if wget was successfull
if [ $? -ne 0 ]
then
      echo "Download failed"
      exit 1
fi

# change context location to root_dir
cd $root_dir

# get file with name fliko-device and ending zip
zip_file_name=$(ls | grep fliko-device | grep .zip)

if [ ! -f $zip_file_name ]
then
      echo "Zip file not found"
      exit 1
fi

# rename zip file to fd.zip
mv $zip_file_name fd.zip
zip_file_name=fd.zip

echo "Unzipping $zip_file_name" 

# unzip in root_dir
unzip -o -q $zip_file_name -d $root_dir
unziped_folder=$(ls -d */ | grep fliko-device)

if [ ! -d $root_dir/$remote_version ]
then
      echo "Moving $root_dir/$unziped_folder to $root_dir/$remote_version"
      mv -f $root_dir/$unziped_folder $root_dir/$remote_version
else
      echo "Deleting $root_dir/$remote_version"
      rm -rf $root_dir/$remote_version

      echo "Moving $root_dir/$unziped_folder to $root_dir/$remote_version"
      mv -f $root_dir/$unziped_folder $root_dir/$remote_version
fi

# remove downloaded file
rm $zip_file_name

# create symlink from fliko-device-linux-x64 to /current
echo "Creating symlink: "
echo $root_dir/$remote_version/
echo $root_dir/current/

ln -nfs $root_dir/$remote_version/* $root_dir/current/

# remove old version
#  TODO: removes it self for now reason????
echo "Removing old version $root_dir/$current_version"
rm -rf $root_dir/$current_version
 
# update version file
echo $remote_version > $root_dir/version.txt
echo "Update complete, updated to $remote_version"

# check if kiosk.servive enabled
if [ $(systemctl is-enabled --user kiosk.service) == 'enabled' ]
then
    # check if kiosk.service inactive
    if [ $(systemctl is-active --user kiosk.service) == 'inactive' ]
    then
        systemctl stop --user kiosk-update.service
        echo "Starting kiosk.service"
        systemctl start --user kiosk.service
        
        # just restart self to make sure that app window would not be on top
        # systemctl restart --user fliko-device.service
    fi
fi