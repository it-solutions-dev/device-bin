# Device binaries

## About

Repository for application binaries.

# OS

-   [Ubuntu](/scripts/ubuntu/)
-   [Windows](/scripts/win/)
    -   Windows kiosk - upload to `C:\kiosk\`, if file `stop.txt` exists in folder kiosk watchdog script will stop

## Download all script set permissions & install app

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/autostart.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/disable.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/enable.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/install.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/local_install.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/off_services.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/on_services.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/ping.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/reboot.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/remove.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/update.sh && \
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/params.sh && \
```

```bash
chmod +x autostart.sh && \
chmod +x disable.sh && \
chmod +x enable.sh && \
chmod +x install.sh && \
chmod +x local_install.sh && \
chmod +x off_services.sh && \
chmod +x on_services.sh && \
chmod +x ping.sh && \
chmod +x reboot.sh && \
chmod +x remove.sh && \
chmod +x update.sh && \
chmod +x params.sh
```

## Create global sh using `params.sh`

Setup `urls` inside `params.sh` file and run it to create global variables

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/params.sh && \
chmod +x params.sh && \
./params.sh
```

## Install

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/install.sh && \
chmod +x install.sh && \
./install.sh $LATEST_OS_RELEASE_URL
```

## Update

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/update.sh && \
chmod +x update.sh && \
./update.sh $LATEST_OS_RELEASE_URL
```

## Remove

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/remove.sh && \
chmod +x remove.sh && \
./remove.sh
```

## Auto starter (update -> start app)

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/autostart.sh && \
chmod +x autostart.sh && \
./autostart.sh $LATEST_OS_RELEASE_URL
```

## Reboot script

-   [Auto restart script](./scripts/ubuntu/reboot.sh) - script receives URL as parameter to get remote settings
-   ```bash
      wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/reboot.sh && \
      chmod +x reboot.sh && \
    ```
-   Example `./reboot.sh <URL>`

## Kiosk display

-   Setup kiosk URL and Display https://wiki.ubuntu.com/X/InputCoordinateTransformation
    -   use echo $DISPLAY to get display number
    -   set correct orreintation for touch screen
    -   90 - (clockwise left to right)
        -   0 -1 1 1 0 0 0 0 1
    -   90 - (counter clockwise from right to left)
        -   0 1 0 -1 0 1 0 0 1
    -   180 - (clockwise or counterclockwise 180°)
        -   -1 0 1 0 -1 1 0 0 1

# Systemd service:

-   Upload services to `~/config/systemd/user/`
-   Reload services `systemctl --user daemon-reload`
-   Enable services:
    -   `systemctl --user enable kiosk.service`
    -   `systemctl --user enable device.service`
-   Start services:
    -   `systemctl --user start kiosk.service`
    -   `systemctl --user start device.service`
-   Check status:

    -   `systemctl --user status kiosk.service`
    -   `systemctl --user status device.service`

-   Servive logs:
    -   `journalctl --user -xeu kiosk.service`
    -   `journalctl --user -xeu device.service`

## Setup journald automatic cleanup

-   `sudo nano /etc/systemd/journald.conf`

-   ```
      # Set the maximum size of the journal logs in bytes
      SystemMaxUse=1G

      # Set the number of days after which logs will be deleted
      MaxRetentionSec=14d
    ```

-   `sudo systemctl restart systemd-journald`

## Kiosk service

Kiosk service - start chrome with given params

-   [Kiosk service](./scripts/ubuntu/services/kiosk.service)
    -   Setup kiosk URL in kiosk serivce
-   [Setup kiosk display](#kiosk-display)

## Device app service

Used to startup device app

-   [Device app service](./scripts/ubuntu/services/device.service)

## `on_services.sh` - Enable service

Change `Google Chrome` to `Chromium` if you are using Chromium

```bash
# From
wmctrl -r "Google Chrome" -b toggle,above

# To
wmctrl -r "Chromium" -b toggle,above

```

## Autostart script (turn on service on boot)

Move `on_services.sh.desktop` to `~/.config/autostart/`
