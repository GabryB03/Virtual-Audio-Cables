@echo off

pushd "%CD%"
CD /D "%~dp0"

net stop audiosrv /y
net stop AudioEndpointBuilder /y
call uninstalldriver.bat
net start audiosrv

SET DEF_COMM_DEV_ID=
SET DEF_MULTIMEDIA_DEV_ID=
SET DEF_CONSOLE_DEV_ID=
FOR /F %%I IN ('AudioEndPointTool.exe get --default --flow=Capture --role=Communications --format=Raw --fields=ID') DO SET "DEF_COMM_DEV_ID=%%I"
FOR /F %%I IN ('AudioEndPointTool.exe get --default --flow=Capture --role=Multimedia --format=Raw --fields=ID') DO SET "DEF_MULTIMEDIA_DEV_ID=%%I"
FOR /F %%I IN ('AudioEndPointTool.exe get --default --flow=Capture --role=Console --format=Raw --fields=ID') DO SET "DEF_CONSOLE_DEV_ID=%%I"

net stop audiosrv /y
net stop AudioEndpointBuilder /y
voicemodcon install mvvad.inf *VMDriver
net start audiosrv

IF NOT "%DEF_COMM_DEV_ID%"=="" (
	AudioEndPointTool.exe setdefault --id="%DEF_COMM_DEV_ID%" --flow=Capture --role=Communications
)
IF NOT "%DEF_MULTIMEDIA_DEV_ID%"=="" (
	AudioEndPointTool.exe setdefault --id="%DEF_MULTIMEDIA_DEV_ID%" --flow=Capture --role=Multimedia
)
IF NOT "%DEF_CONSOLE_DEV_ID%"=="" (
	AudioEndPointTool.exe setdefault --id="%DEF_CONSOLE_DEV_ID%" --flow=Capture --role=Console
)
