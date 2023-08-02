#!/bin/bash

function version
{
      echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; 
}

function format_json_file() 
{
      jq . $1 > $1.tmp && mv $1.tmp $1
}

root_dir=~/kiosk/fliko-device
cache_dir=./cache
latest_json_file=$cache_dir/latest.json

# check if root_dir or version file exists
# check if version file exists

processes=$(ps -ef | grep fliko-device | grep -v grep)

if [ -z "$processes" ]
then
      echo "No fliko-device processes running"
else
      echo "Killing fliko-device processes"
      echo "$processes" | awk '{print $2}' | xargs kill -9
fi

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

curl -s -o $latest_json_file https://api.github.com/repos/it-solutions-dev/device-bin/releases/latest

# making sure that json file formatted for grep
format_json_file $latest_json_file

current_version=$(cat $root_dir/version.txt)
remote_version=$(cat $latest_json_file | grep '"tag_name"' | grep -Eo '[0-9]+.[0-9]+.[0-9]+')

# compare versions
if [ $(version $current_version) -ge $(version $remote_version) ]
then
      echo "Current version is $current_version"
      echo "Remote version is $remote_version"
      exit 0
fi

# find download url
download_url=$(cat $latest_json_file | grep '"browser_download_url"' | grep .zip | grep -Eo 'https://[^ >]+\w' | head -1)

echo "Downloading $download_url"
wget $download_url -P $root_dir

# change context location to root_dir
cd $root_dir

# get file with name fliko-device and ending zip
zip_file_name=$(ls | grep fliko-device | grep .zip)

# rename zip file to fd.zip
mv $zip_file_name fd.zip
zip_file_name=fd.zip

echo "Unzipping $zip_file_name" 

# unzip in root_dir
unzip -o -q $zip_file_name -d $root_dir
unziped_folder=$(ls -d */ | grep fliko-device)

# rsync or mv folder to remote_version folder
if [ ! -d $root_dir/$remote_version ]
then
      mv -f $root_dir/$unziped_folder $root_dir/$remote_version
else
      rsync -a $root_dir/$unziped_folder/ $root_dir/$remote_version
fi

# remove downloaded file
rm $zip_file_name

# create symlink from fliko-device-linux-x64 to /current
echo "Creating symlink: "
echo  $root_dir/$remote_version/* 
echo $root_dir/current/
ln -nfs $root_dir/$remote_version/* $root_dir/current/

# remove old version
rm -rf $root_dir/$current_version
 
# update version file
echo $remote_version > $root_dir/version.txt
echo "Update complete, updated to $remote_version"

# check if service is enabled and not running start it