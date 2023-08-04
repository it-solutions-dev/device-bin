#!/bin/bash

# try to update autostart receives url as argument (lastest version url)

~/kiosk/update.sh $1

echo "Starting fliko-device"
~/kiosk/fliko-device/current/fliko-device