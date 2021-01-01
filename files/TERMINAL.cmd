@ECHO OFF

:: Minecraft PE World Exporter (diagnostic terminal)
::
:: Created by Tikolu - http://tikolu.net
:: Report issues to tikolu43@gmail.com

TITLE Minecraft PE World Exporter - Terminal
ECHO This Terminal is for diagnostic purposes only.
ECHO To use the World Exporter, run exporter.cmd from the root folder.
:0
CD %~dp0
ECHO.
ECHO.
ECHO.
ECHO 1 - Restart ADB
ECHO 2 - Get connected device information
ECHO 3 - Check if Minecraft is installed
ECHO 4 - Send backup request to device
ECHO 5 - Extract backup
ECHO 6 - Extract archive
ECHO 7 - Check size of backup and archive
ECHO 8 - Display "minecraftWorlds" folder
ECHO 9 - Stop ADB
ECHO.
ECHO 10 - Manually enter commands
ECHO.
ECHO.
SET input=8
SET /p input="Enter your choice: "
IF %input% GTR 9 GOTO 10
IF %input% LSS 1 GOTO 8
GOTO %input%

:1
adb0 kill-server
adb0 start-server
PAUSE
GOTO 0

:2
adb0 get-state
PAUSE
GOTO 0

:3
adb0 shell pm path com.mojang.minecraftpe
PAUSE
GOTO 0

:4
adb0 backup -noapk com.mojang.minecraftpe
PAUSE
GOTO 0

:5
java -jar abe.jar unpack backup.ab backup.tar
PAUSE
GOTO 0

:6
7zip x -y -obackup backup.tar
PAUSE
GOTO 0

:7
ECHO Size of backup.ab:
CALL getFileSize.cmd backup.ab
ECHO Size of backup.tar:
CALL getFileSize.cmd backup.tar
PAUSE
GOTO 0

:8
ECHO Opening folder in Explorer
explorer "backup\apps\com.mojang.minecraftpe\r\games\com.mojang\minecraftWorlds"
GOTO 0

:9
adb0 kill-server
PAUSE
GOTO 0

:10
ECHO.
SET /p input="%CD%>"
%input%
GOTO 10
