#!/bin/bash

systemctl daemon-reload --user

systemctl restart --user device.service
systemctl restart --user kiosk.service
systemctl restart --user ping.service
systemctl restart --user reboot.service

sleep 1
wmctrl -r "Google Chrome" -b toggle,above