#!/bin/bash

systemctl daemon-reload --user

systemctl stop --user device.service
systemctl stop --user kiosk.service
systemctl stop --user ping.service
systemctl stop --user reboot.service