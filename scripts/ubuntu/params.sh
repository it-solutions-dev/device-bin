# #!/bin/bash

if [ ! -f ~/.env ]; then
    touch ~/.profile
fi

echo export DEVICE_UPDATE_PAGE_URL=url >> ~/.profile
echo export DEVICE_SETUP_URL=url >> ~/.profile
echo export DEVICE_PING_URL=url >> ~/.profile
echo export DEVICE_PUBLIC_PARAMS_URL=url >> ~/.profile
echo export LATEST_OS_RELEASE_URL=url >> ~/.profile

