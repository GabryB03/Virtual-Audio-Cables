@echo off

set LOGFILE=uninstalldriver.log
set /A "index=0"
set /A "count=15"

:loop
REM START BY FINDING THE OEM INF FILE
setlocal EnableDelayedExpansion
SET OEM_FILE=
set oemdata="voicemodcon.exe dp_enum"
FOR /F "eol=. tokens=*" %%a IN ( '%oemdata%' ) DO (
    set line=%%a
    set ourline=!line:Voicemod=!
    if not !line!==!ourline! (
        SET OEM_FILE=!prev_line!
    )
    SET prev_line=%%a
)
echo Installed OEM file found as: !OEM_FILE! >>%LOGFILE%
setlocal DisableDelayedExpansion

IF "%OEM_FILE%" == "" (
    echo Could not locate OEM file installed. No INF to remove. >>%LOGFILE%
    goto :success
)

REM REMOVE THE DEVICE
voicemodcon.exe remove *VMDriver
if NOT %errorlevel% == 0 (
    echo Can not remove Virtual device, error %errorlevel% >>%LOGFILE%
    exit /b %errorlevel%
)
echo Virtual device successfully uninstalled from the system >>%LOGFILE%

voicemodcon.exe dp_delete %OEM_FILE%
if NOT %errorlevel% == 0 (
    echo Can not delete the inf file named %OEM_FILE% from DriverStore, error %errorlevel% >>%LOGFILE%
    exit /b %errorlevel%
)
echo OEM file %OEM_FILE% successfully deleted from the DriverStore >>%LOGFILE%

set /A "index=index + 1"
if %index% geq %count% (
  echo Maximum index reached >>%LOGFILE%
  goto :success
)
echo Check for another stored Voicemod driver >>%LOGFILE%
goto :loop

:success
echo Success >>%LOGFILE%
exit /b 0
