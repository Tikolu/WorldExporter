@ECHO OFF

:: Minecraft PE World Exporter (diagnostic terminal)
::
:: Created by Tikolu - http://tikolu.net
:: Report issues to tikolu43@gmail.com

TITLE Minecraft PE World Exporter - Terminal
ECHO This Terminal is for diagnostic purposes only.
ECHO To use the World Exporter, run exporter.cmd from the root folder.
:0
ECHO.
ECHO.
ECHO 1 - Get connected device information
ECHO 2 - Check if Minecraft is installed
ECHO 3 - Send backup request to device
ECHO 4 - Extract backup
ECHO 5 - Extract archive
ECHO 6 - Check size of backup and archive
ECHO 7 - Display "minecraftWorlds" folder
ECHO 8 - Manually enter commands
ECHO.
SET input=8
SET /p input="Enter your choice: "
IF %input% GTR 8 GOTO 8
IF %input% LSS 1 GOTO 8
GOTO %input%

:1
adb0 get-state
PAUSE
GOTO 0

:2
adb0 shell pm path com.mojang.minecraftpe
PAUSE
GOTO 0

:3
adb0 backup -noapk com.mojang.minecraftpe>NUL
PAUSE
GOTO 0

:4
java -jar abe.jar unpack backup.ab backup.tar
PAUSE
GOTO 0

:5
7zip x -y -obackup backup.tar
PAUSE
GOTO 0

:6
ECHO Size of backup.ab:
CALL getFileSize.cmd backup.ab
ECHO Size of backup.tar:
CALL getFileSize.cmd backup.tar
PAUSE
GOTO 0

:7
ECHO Opening folder in Explorer
explorer "backup\apps\com.mojang.minecraftpe\r\games\com.mojang\minecraftWorlds"
GOTO 0

:8
ECHO.
SET /p input="%CD%>"
%input%
GOTO 8
