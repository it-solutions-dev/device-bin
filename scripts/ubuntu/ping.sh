#!/bin/bash

function init() 
{
    version_file=~/kiosk/fliko-device/version.txt

    if [ ! -f $version_file ]
    then
        echo "Version file not found"
        return
    fi

    version=$(cat $version_file)

    curl -s -X PATCH -H "Content-Type: application/json" -d '{"version": "'$version'"}' $1
}

while true
do
    init $1
    sleep 300
done