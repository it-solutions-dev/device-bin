#!/bin/bash

systemctl daemon-reload --user

systemctl enable --user ping.service
systemctl enable --user reboot.service
