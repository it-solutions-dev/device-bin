@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    [INFO] Starting POS.SA97 Registry Update
echo ================================================

set CLSID=
set CLSID_PATH=
set APPID_KEY=

:: Step 1: Search for POS.SA97 string in registry
echo [STEP 1] Searching registry for 'POS.SA97'...

for /f "tokens=*" %%K in ('reg query "HKCR\WOW6432Node\CLSID" 2^>nul') do (
    for /f "tokens=*" %%V in ('reg query "%%K" /s /f "POS.SA97" 2^>nul ^| findstr /i "POS.SA97"') do (
        for %%G in (%%K) do set CLSID=%%~nxG
        set CLSID_PATH=%%K
        goto :found
    )
)

echo [ERROR] Could not find any CLSID key containing 'POS.SA97'.
goto :pause_and_exit

:found
echo [INFO] Found CLSID: !CLSID!
echo [INFO] CLSID Key Path: !CLSID_PATH!

:: Step 2: Check and add AppID if missing
echo [STEP 2] Ensuring AppID is set...
reg query "!CLSID_PATH!" /v AppID >nul 2>&1
if %errorlevel%==0 (
    echo [SKIP] AppID already exists in CLSID key.
) else (
    reg add "!CLSID_PATH!" /v AppID /t REG_SZ /d !CLSID! /f >nul
    if %errorlevel%==0 (
        echo [INFO] AppID=!CLSID! added to CLSID key.
    ) else (
        echo [ERROR] Failed to add AppID value.
        goto :pause_and_exit
    )
)

:: Step 3: Check and create AppID\{GUID} key
set "APPID_KEY=HKCR\WOW6432Node\AppID\!CLSID!"
echo [STEP 3] Checking AppID key: !APPID_KEY!
reg query "!APPID_KEY!" >nul 2>&1
if %errorlevel%==0 (
    echo [SKIP] AppID key already exists.
) else (
    reg add "!APPID_KEY!" /f >nul
    if %errorlevel%==0 (
        echo [INFO] AppID key created.
    ) else (
        echo [ERROR] Failed to create AppID key.
        goto :pause_and_exit
    )
)

:: Step 4: Add DllSurrogate (blank) if not exists
echo [STEP 4] Ensuring DllSurrogate value exists...
echo [DEBUG] AppID_KEY value: !APPID_KEY!

set "QUERY_RESULT=1"
reg query "!APPID_KEY!" /v DllSurrogate >nul 2>&1
set "QUERY_RESULT=%errorlevel%"
echo [DEBUG] Query result: !QUERY_RESULT!

if "!QUERY_RESULT!"=="0" (
    echo [SKIP] DllSurrogate already exists.
) else (
    echo [DEBUG] About to add DllSurrogate value
    set "ADD_RESULT=1"
    reg add "!APPID_KEY!" /v DllSurrogate /t REG_SZ /d " " /f >nul 2>&1
    set "ADD_RESULT=%errorlevel%"
    echo [DEBUG] Add result: !ADD_RESULT!
    
    if "!ADD_RESULT!"=="0" (
        echo [INFO] DllSurrogate added (empty).
    ) else (
        echo [ERROR] Failed to add DllSurrogate value.
        goto :pause_and_exit
    )
)

echo ================================================
echo [DONE] Registry changes completed successfully.
echo CLSID: !CLSID!
echo CLSID Key: !CLSID_PATH!
echo AppID Key: !APPID_KEY!
echo ================================================

:pause_and_exit
echo.
pause
endlocal
