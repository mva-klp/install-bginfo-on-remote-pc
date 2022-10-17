@cd/d "%~dp0"
@echo off
setlocal ENABLEDELAYEDEXPANSION
set "file=.\hosts.txt"
echo "Date: %DATE% time: %TIME%" > .\result_install_BGingo.csv
FOR /F %%x IN ('findstr /B /V /C:# %file%') DO (
ping %%x -n 1 | find "TTL=" > nul
if errorlevel 1 (
echo %%x offline
echo ***************************************************
echo %%x;offline >> .\result_install_BGingo.csv
) else (
echo install on %%x
xcopy .\BGInfo "\\%%x\c$\BGInfo" /e /y /i
echo reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Bginfo /t REG_SZ /d "C:\BGInfo\Bginfo64.exe C:\BGInfo\conf-bginfo.bgi /NOLICPROMPT /TIMER:0" /f > C:\reg.bat
xcopy "C:\reg.bat" "\\%%x\c$"
wmic /node:"%%x" process call create "C:\reg.bat"
TIMEOUT /T 5 /NOBREAK
del /f /q "C:\reg.bat"
del /f /q "\\%%x\c$\reg.bat"
echo reg files was deleted
echo ***************************************************
echo %%x;ok >> .\result_install_BGingo.csv
)
)
pause