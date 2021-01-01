@ECHO OFF

:: Android Driver Installer
::
:: Created by Tikolu - http://tikolu.net
:: Report issues to tikolu43@gmail.com

:SETUP
TITLE Android Driver Installer by Tikolu
CD %~dp0
IF NOT EXIST "files" GOTO FILEERROR
CD files
GOTO INTRODUCTION

:INTRODUCTION
ECHO Android Driver Installer by Tikolu
ECHO ==================================
ECHO.
ECHO Press enter to install Android Drivers
PAUSE>NUL
IF DEFINED programfiles(x86) GOTO x64
GOTO x86

:FILEERROR
CLS
ECHO An error was encountered when trying to access necessary files.
ECHO Please make sure that the ZIP file is extracted before installing drivers.
PAUSE>NUL
EXIT

:x86
START /wait GoogleAndroidDriver86 /f 2>NUL
GOTO END

:x64
START /wait GoogleAndroidDriver64 /f 2>NUL
GOTO END

:END
CLS
ECHO Android drivers should now be installed.
ECHO Press enter to restart your computer.
PAUSE>NUL
ECHO Restarting...
SHUTDOWN /r -t 0