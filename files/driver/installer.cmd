@ECHO OFF

:: Minecraft PE World Exporter (driver installer)
::
:: Created by Tikolu - http://tikolu.net
:: Report issues to tikolu43@gmail.com

IF "%1"=="install" GOTO ARCH
ECHO To use the World Exporter, run exporter.cmd from the root folder.
ECHO Press enter to exit.
PAUSE>NUL
EXIT /B
:ARCH
IF DEFINED programfiles(x86) GOTO x64
:x86
ECHO(
PING localhost -n 1 >NUL
START /wait GoogleAndroidDriver86 /f 2>NUL
EXIT /B
:x64
ECHO(
PING localhost -n 1 >NUL
START /wait GoogleAndroidDriver64 /f 2>NUL
EXIT /B
