call :sub > %TEMP%\wu.log 2>&1 
exit /b

:sub

date /t
time /t

net stop wuauserv

REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientIDValidation /F

REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v LastWaitTimeout /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v NextDetectionTime /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v BalloonType /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v BalloonTime /F
REG DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate /va /f

REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate /v WUServer /d "http://SERVIDOR" /f
REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate /v WUStatusServer /d "http://SERVIDOR" /f
REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v UseWUServer /t REG_DWORD /d 1 /f

rem REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate /v TargetGroup /d "Servers" /f
rem REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate /v TargetGroupEnabled /t REG_DWORD /d 1 /f

REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 4 /f
REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 0 /f
REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v ScheduledInstallDay /t REG_DWORD /d 0 /f
REG ADD HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v ScheduledInstallTime /t REG_DWORD /d 9 /f
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUState /t REG_DWORD /d 2 /f
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f

net start wuauserv

set WUAUCLT=

dir /s /b c:\wuauclt.exe > %TEMP%\dir.tmp

for /f %%L in (%TEMP%\dir.tmp) do ( set WUAUCLT="%%L" )

%WUAUCLT% /resetauthorization /detectnow

date /t
time /t
