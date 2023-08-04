# Device binaries

## About
Repository for application binaries.


# Ubuntu

Install jq for json parsing and shell scripts https://jqlang.github.io/jq/download/

```bash
    sudo apt-get install jq
```

Install wmctrl control windows from command line

```bash
    sudo apt-get install wmctrl
```

## Download all script set permissions install app

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/install.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/update.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/remove.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/autostart.sh && \
```

```bash
chomod +x install.sh && \
chomod +x update.sh && \
chomod +x remove.sh && \
chomod +x autostart.sh 
```

## Install

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/install.sh && \
chomod +x install.sh && \
./install.sh
```

## Update

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/update.sh && \
chomod +x update.sh && \
./update.sh
```

## Remove

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/remove.sh && \
chomod +x remove.sh && \
./remove.sh
```

## Auto starter (update -> start app)

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/autostart.sh && \
chomod +x autostart.sh && \
./autostart.sh
```

## Reboot script 

- [Auto restart script](./scripts/ubuntu/reboot.sh) - script receives URL as parameter to get remote settings
- ```bash
    wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/reboot.sh && \
    chomod +x reboot.sh && \
    ```
- Example `./reboot.sh <URL>`




## Kiosk display

- Setup kiosk URL and Display https://wiki.ubuntu.com/X/InputCoordinateTransformation
    - use echo $DISPLAY to get display number
    - set correct orreintation for touch screen
    - 90 - (clockwise left to right) 
        * 0 -1 1 1 0 0 0 0 1
    - 90 - (counter clockwise from right to left) 
        * 0 1 0 -1 0 1 0 0 1
    - 180 - (clockwise or counterclockwise 180°) 
        *   -1 0 1 0 -1 1 0 0 1

# Systemd service:

- Upload services to `~/config/systemd/user/`
- Reload services `systemctl --user daemon-reload`
- Enable services:
    - `systemctl --user enable kiosk.service`
    - `systemctl --user enable fliko-device.service`
- Start services: 
    - `systemctl --user start kiosk.service`
    - `systemctl --user start fliko-device.service`
- Check status:
    - `systemctl --user status kiosk.service`
    - `systemctl --user status fliko-device.service`

- Servive logs:
    - `journalctl --user -xeu kiosk.service`
    - `journalctl --user -xeu fliko-device.service`
## Setup journald automatic cleanup

- `sudo nano /etc/systemd/journald.conf`

- ```
    # Set the maximum size of the journal logs in bytes
    SystemMaxUse=1G
    
    # Set the number of days after which logs will be deleted
    MaxRetentionSec=14d
    ```

- `sudo systemctl restart systemd-journald`

## Kiosk service

Kiosk service - start chrome with given params 
- [Kiosk service](./scripts/ubuntu/services/kiosk.service)
    - Setup kiosk URL in kiosk serivce
- [Setup kiosk display](#kiosk-display)


## Device app service 

Used to startup device app
- [Device app service](./scripts/ubuntu/services/fliko-device.service)
