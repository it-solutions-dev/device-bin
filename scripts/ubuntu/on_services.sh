#!/bin/bash

systemctl daemon-reload --user

systemctl restart --user device.service
systemctl restart --user kiosk.service
systemctl restart --user ping.service
systemctl restart --user reboot.service

sleep 2

# Change Google Chrome to Chromium if you are using Chromium
wmctrl -r "Google Chrome" -b toggle,above