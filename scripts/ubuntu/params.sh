# #!/bin/bash

if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
fi

echo export DEVICE_UPDATE_PAGE_URL=url >> ~/.bashrc
echo export DEVICE_SETUP_URL=url >> ~/.bashrc
echo export DEVICE_PING_URL=url >> ~/.bashrc
echo export DEVICE_PUBLIC_PARAMS_URL=url >> ~/.bashrc
echo export LATEST_OS_RELEASE_URL=url >> ~/.bashrc

