@echo off

SET VM_DEV_MIC_ID=
FOR /F %%I IN ('AudioEndPointTool.exe get --name=Voicemod --flow=Capture --format=Raw --fields=ID') DO SET "VM_DEV_MIC_ID=%%I"
IF NOT "%VM_DEV_MIC_ID%"=="" (
	AudioEndPointTool.exe setvisibility --id="%VM_DEV_MIC_ID%" --visible=false
)
