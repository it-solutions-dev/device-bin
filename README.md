# Device binaries

## About
Repository for application binaries.


# Ubuntu

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
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/install.sh
chomod +x install.sh
./install.sh
```

## Update

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/update.sh
chomod +x update.sh
./update.sh
```

## Remove

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/remove.sh
chomod +x remove.sh
./remove.sh
```

## Auto starter (update -> start app)

```bash
wget https://raw.githubusercontent.com/it-solutions-dev/device-bin/master/scripts/ubuntu/autostart.sh
chomod +x autostart.sh
./autostart.sh
```


## Kiosk service

- Kiosk service - start chrome with given params show always start and restart if crashes + setup touch screen

```bash
[Unit]
Description=Kiosk service
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0.0
Type=simple
ExecStartPre=-/usr/bin/xinput set-prop "Nexio Touch Device (HS) Nexio HID Multi-Touch ATI0400-10"  --type=float "Coordinate Transformation Matrix" 0.0, -1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0
ExecStartPre=-/usr/bin/xset s off
ExecStartPre=-/usr/bin/xset s noblank
ExecStartPre=-/usr/bin/xset -dpms
ExecStartPre=-/bin/sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/kiosk/.config/chromium/Default/Preferences
ExecStartPre=-/bin/sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/kiosk/.config/chromium/Default/Preferences
ExecStartPre=-/bin/bash -c '/usr/bin/unclutter -idle 0.5 -root &'
ExecStart=/bin/bash -c 'google-chrome --check-for-update-interval=31536000 --noerrdialogs --disable-infobars --disable-pinch -overscroll-history-navigation=0 --autoplay-policy=no-user-gesture-required --enable-features=OverlayScrollbar --password-store=basic --kiosk <REPLACE WITH YOUR URL>'
Restart=always
User=kiosk
Group=kiosk

[Install]
WantedBy=graphical.target
```

