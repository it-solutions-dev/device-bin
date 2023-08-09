#!/bin/bash

# try to update autostart receives url as argument (lastest version url)

~/kiosk/update.sh $1

# starting kiosk service


echo "Starting device"
~/kiosk/fliko-device/current/fliko-device