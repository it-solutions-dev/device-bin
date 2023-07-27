#!/bin/bash

# kill any running fliko-device process
ps -ef | grep fliko-device | grep -v grep | awk '{print $2}' | xargs kill -9

# maybe run update script first


# start fliko-device
fliko-device

