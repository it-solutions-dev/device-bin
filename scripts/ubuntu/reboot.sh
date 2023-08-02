#!/bin/bash

function check_for_file() 
{
    if [ ! -f $1 ]
    then
        echo "Creating $1 file"
        mkdir -p $(dirname $1) && touch $1;
    fi
}

function format_json_file() 
{
    jq . $1 > $1.tmp && mv $1.tmp $1
}

function init()
{
    endpoint=$1
    reboot_lock_file=./kiosk/cache/reboot.lock
    public_params_json=./kiosk/cache/public_params.json
    new_public_params_json=./kiosk/cache/new_public_params.json

    current_hour=$(date +%H)
    current_minutes=$(date +%M)

    check_for_file $public_params_json
    check_for_file $new_public_params_json

    status=$(curl -o $new_public_params_json -s -w "%{http_code}\n" $endpoint)

    format_json_file $new_public_params_json

    echo "Status code is $status"

    settings=$(cat $new_public_params_json)

    if [ $status -ne 200 ]
    then
        echo "Using old settings"
        settings=$(cat $public_params_json)
    else
        echo "Using new settings"
        mv $new_public_params_json $public_params_json
    fi

    # get time from public_params.json and remove all spaces
    restart_time=$(cat $public_params_json | grep '"restart_time"' | grep -Eo '[0-9]+' | tr -d '\n')
    lock=$(cat $public_params_json | grep '"restart_time_lock"' | tr -d 'restart_time_lock' | grep -Eo '[0-9a-zA-Z]+')

    if [[ -z $restart_time || $lock == "false" ]]
    then
        echo "Reboot disabled"
        return
    fi

    # get hour and minutes from remote time
    remote_hour=$(echo $restart_time | head -c 2)
    remote_minute=$(echo $restart_time | tail -c 3)

    echo "Current time: $current_hour:$current_minutes"
    echo "Remote time: $remote_hour:$remote_minute"
    echo "Remote lock: $lock"

    # check if lock exist with same lock
    check_for_file $reboot_lock_file

    # check if file reboot lock file empty
    if [ -z $(cat $reboot_lock_file) ]
    then
        echo "Lock empty"
    else 
        lock_content=$(cat $reboot_lock_file)
        echo "Current lock: $lock_content"
        if [ $lock == $lock_content ]
        then
            echo "Lock same, reboot already took place"
            return
        fi
    fi

    # check if same hour
    if [ $remote_hour -eq $current_hour ]
    then
        echo "Same hour"
        # check if minutes are same or less
        if [ $remote_minute -le $current_minutes ]
        then
            echo "Rebooting"
            echo $lock > $reboot_lock_file
            reboot
        else 
            echo "Skipping, too early"
            return
        fi
    else 
        echo "Not the time yet"
        return
    fi
}

# loop inint function every 5 minutes
echo "Reboot script started"

while true
do
    init $1
    sleep 900
done

