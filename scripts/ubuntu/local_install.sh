#!/bin/bash

# accept url as argument for release install

function format_json_file() 
{
      jq . $1 > $1.tmp && mv $1.tmp $1
}

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

# making sure that json file formatted for grep
format_json_file $latest_file

# extract download and version number
zip_path=$1

version=$(echo $zip_path | grep -Eo '\-[0-9]+.[0-9]+.[0-9]+' | grep -Eo '[0-9]+.[0-9]+.[0-9]+')

echo "Version is $version"
echo "Path is $zip_path"

echo "Moving $zip_path to $root_dir"

cp $zip_path $root_dir

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



# check if version folder exists

if [ ! -d $root_dir/$version ]
then
      mv -f $root_dir/$unziped_folder $root_dir/$version
else
      rsync -a $root_dir/$unziped_folder/ $root_dir/$version
fi

# remove downloaded file
rm $zip_file_name

# create symlink from fliko-device-linux-x64 to /current
ln -nfs $root_dir/$version/* $root_dir/current/

# record version to file
echo $version > $version_file

#publish path to bashrc
echo 'Adding /kiosk/fliko-device/current to PATH'
echo "export PATH=$PATH:$root_dir/current" >> ~/.bashrc

# restart bash
source ~/.bashrc