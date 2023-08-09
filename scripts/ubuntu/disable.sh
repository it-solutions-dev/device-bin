#!/bin/bash

systemctl daemon-reload --user

systemctl disable --user ping.service
systemctl disable --user reboot.service

