@echo off

REM === Configuration ===
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "FLIKO_PATH=%LOCALAPPDATA%\fliko_device\fliko-device.exe"
set "CHECK_INTERVAL=5"
set "KIOSK_URL=URL"

if not exist "%CHROME_PATH%" (
    echo ERROR: Chrome not found at "%CHROME_PATH%"
    echo Please install Chrome or update the path in this script
    exit /b 1
)

if not exist "%FLIKO_PATH%" (
    echo ERROR: Fliko device not found at "%FLIKO_PATH%"
    echo Please install Fliko device or update the path in this script
    exit /b 1
)

echo Kiosk Watchdog Started - %date% %time%
echo Press Ctrl+C to stop or create 'stop.txt' file

REM === Check if fliko-device is running ===
echo Starting Kiosk...

:Loop 
tasklist /fi "imagename eq chrome.exe" | find /i "chrome.exe" >nul
if errorlevel 1 (
    echo Kiosk stopped, starting...
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk --disk-cache-size=1 --v8-cache-options=none --incognito --check-for-update-interval=31536000 --noerrdialogs --disable-infobars --disable-pinch --overscroll-history-navigation=0 --autoplay-policy=no-user-gesture-required --enable-features=OverlayScrollbar --password-store=basic "%KIOSK_URL%"
)

tasklist /fi "imagename eq fliko-device.exe" | find /i "fliko-device.exe" >nul
if errorlevel 1 (
    echo Starting fliko-device...
    REM === Verify required files exist ===
    start "" "%FLIKO_PATH%" --service-mode
)

REM === Check for stop.txt trigger ===
if exist "C:\kiosk\stop.txt" (
    echo [%time%] stop.txt detected, exiting watchdog...
    del stop.txt
    timeout /t %CHECK_INTERVAL% >nul
    exit /b 0
)

timeout /t %CHECK_INTERVAL% >nul 2>&1
goto Loop