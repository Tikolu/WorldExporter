:: Minecraft PE World Exporter
:: Version 2.8
::
:: Created by Tikolu - https://tikolu.net/world-exporter
:: Report issues to tikolu43@gmail.com


:SETUP
@ECHO OFF
title Minecraft PE World Exporter tool by Tikolu - Version 2.8
color 0f
CD %~dp0
SET heading=MCPE World Exporter by Tikolu
SET divider==================================
SET email=tikolu43@gmail.com
SET url=https://tikolu.net/world-exporter/logexternal.php?
IF NOT EXIST "files\temp" GOTO FILEERROR
CD files
ECHO test>temp
SET /p writetest=<temp
IF NOT [%writetest%]==[test] GOTO FILEERROR
fc temp temp>NUL
IF [%errorlevel%]==[0] GOTO FILESYSTEMOK
ECHO Filesystem is broken or corrupted. WorldExporter cannot run.
PAUSE>NUL
EXIT
:FILESYSTEMOK
java -jar abe.jar>temp 2>&1
fc temp abe_info>NUL
IF NOT [%errorlevel%]==[0] GOTO JAVANOTINSTALLED
IF EXIST "..\minecraftWorlds" GOTO WORLDFOLDEREXISTS
CLS
ECHO Launching ADB...
adb0 kill-server>nul
adb0 start-server>nul
ECHO Getting device state...
adb0 get-state>temp
SET /p deviceState=<temp
IF [%deviceState%]==[device] GOTO BACKUP
GOTO INTRODUCTION

:FILEERROR
CLS
ECHO An error was encountered when trying to access necessary files.
ECHO Please make sure that the ZIP file is extracted before using World Exporter.
ECHO If you need help, please contact %email%
CURL -s "%url%log=error&error=file"
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:JAVANOTINSTALLED
CLS
ECHO Java was not detected on your system.
ECHO Please make sure Java is installed.
ECHO If you need help, please contact %email%
CURL -s "%url%log=error&error=java"
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:WORLDFOLDEREXISTS
CLS
ECHO The "minecraftWorlds" folder inside WorldExporter's directory must be deleted (or renamed) before exporting new worlds.
ECHO.
ECHO Press enter to delete the folder and continue.
PAUSE>NUL
RMDIR "%~dp0\minecraftWorlds" /s /q
GOTO SETUP

:MINECRAFTNOTINSTALLED
CLS
ECHO Minecraft was not detected on your device.
ECHO.
ECHO If Minecraft is installed, this means that there is an error communicating with
ECHO your device. Please contact my email, %email%
CURL -s "%url%log=error&error=nominecraft"
ECHO.
PAUSE>NUL
EXIT

:BACKUPERROR
CLS
ECHO Something went wrong during the extraction process.
ECHO.
ECHO But don't give up yet!
ECHO This might be due to a few different reasons, so email me and I will respond as soon as possible.
ECHO My email: %email%
ECHO.
CURL -s "%url%log=error&error=backup"
ECHO Please include this information in your email:
IF EXIST "backup.ab" ECHO backup.ab is ok
ECHO backup size is %backupSize%
IF EXIST "backup.tar" ECHO backup.tar is ok
PAUSE>NUL
EXIT

:EMPTYBACKUP
CLS
ECHO The backup file which has been exported is blank.
ECHO Try restarting your device and computer, and then running WorldExporter again.
CURL -s "%url%log=error&error=blankbackup"
ECHO.
ECHO If the error persists, contact %email%. You can include some diagnostic information in your email,
ECHO press enter now to reveal the diagnostic information...
PAUSE>NUL
CLS
TREE backup
PAUSE>NUL
EXIT

:INTRODUCTION
CLS
ECHO Welcome to Minecraft World Exporter
ECHO ===================================
ECHO.
ECHO You can use this tool to export worlds from Minecraft Pocket Edition if you have set
ECHO your storage type to "Application" in the settings.
ECHO.
ECHO This program was created by Tikolu. If you experience any problems during the
ECHO process, please contact me at %email%. Documentation: tikolu.net/world-exporter
ECHO.
ECHO Whenever you're ready, press enter.
PAUSE>NUL
GOTO DEBUGGING

:DEBUGGING
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO USB Debugging needs to be enabled for this program to connect to your device. Follow these steps:
ECHO.
ECHO 1. Go to your Android device settings.
ECHO 2. Scroll down to the bottom and click on "System" and then "About Device".
ECHO 3. Find "Build Number" and tap it a few times until you get a message saying "You are a developer".
ECHO 4. Go out of "About Device" and back into "System". A new "Developer Options" menu should now be here.
ECHO 5. Open it and scroll down to "USB DEBUGGING". Make sure that it is ENABLED.
ECHO.
ECHO 6. Connect the device to your computer with a USB cable.
ECHO 7. After connecting a popup will ask "Allow USB Debugging?". Tap on "Allow".
ECHO.
ECHO If nothing happens after pressing "Allow", you may need to install drivers for your device.
ECHO Drivers can be downloaded from:   tikolu.net/world-exporter/download/drivers
adb0 wait-for-device
GOTO BACKUP

:BACKUP
adb0 shell pm path com.mojang.minecraftpe>temp
SET /p minecraftPath=<temp
IF [%minecraftPath%]==[] GOTO MINECRAFTNOTINSTALLED
ECHO.
ECHO Device connected. Please wait...
adb0 shell am force-stop com.mojang.minecraftpe
adb0 shell am start com.mojang.minecraftpe/.MainActivity>NUL
TIMEOUT /T 3 >NUL
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO A backup request has been sent to your device. This will get Minecraft's data and move it to your computer.
ECHO.
ECHO Please tap on "Back up my data" to begin the backup procedure (do not enter a password).
ECHO This might take a few minutes, depending on how many worlds you have.
IF EXIST "backup.ab" DEL backup.ab
IF EXIST "backup.tar" DEL backup.tar
adb0 backup -noapk com.mojang.minecraftpe>NUL
GOTO EXTRACTION

:EXTRACTION
ECHO.
ECHO Backup copied from device. You may unplug your device now.
IF NOT EXIST "backup.ab" GOTO BACKUPERROR
CALL getFileSize.cmd backup.ab>temp
SET /p backupSize=<temp
IF [%backupSize%]==[0] GOTO BACKUPERROR
IF EXIST "backup" RMDIR backup /s /q
MKDIR backup
ECHO Extracting backup file...
IF NOT EXIST "backup.ab" GOTO BACKUPERROR
java -jar abe.jar unpack backup.ab backup.tar
IF NOT EXIST "backup.tar" GOTO BACKUPERROR
ECHO Extracting archive...
7zip x -y -obackup backup.tar>NUL
ECHO Moving "minecraftWorlds" folder to WorldExporter directory...
:: 3 Billion Devices run Tikolu World Exporter
IF NOT EXIST "backup\apps\com.mojang.minecraftpe\r\games\com.mojang" GOTO EMPTYBACKUP
CD "backup\apps\com.mojang.minecraftpe\r\games\com.mojang"
IF EXIST "%~dp0\minecraftWorlds" GOTO WORLDFOLDEREXISTS
MOVE "minecraftWorlds" "%~dp0">NUL
ECHO Cleaning up after extraction...
CD "..\..\..\..\..\.."
RMDIR backup /s /q
IF EXIST "backup.ab" DEL backup.ab
IF EXIST "backup.tar" DEL backup.tar
adb0 kill-server>nul
ECHO World Export Complete!
dir /a:d "..\minecraftWorlds" | find /c "<DIR>">temp
SET /p worlds=<temp
CURL -s "%url%log=success&worlds=%worlds%&source=github"
explorer "..\minecraftWorlds"
GOTO END

:END
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO The worlds have been exported!
ECHO You should now find a "minecraftWorlds" folder in the WorldExporter directory.
ECHO.
ECHO Thank you for using my tool. If it helped you today, please let me know by
ECHO emailing %email%! If you experienced any issues, errors or if
ECHO you just have a general suggestion about the program, also let me know!
ECHO.
ECHO WorldExporter is (and always will be) a free to use project.
ECHO However, you can support future development of WorldExporter
ECHO by donating. Any amount will be greatly appreciated!
ECHO.
ECHO Information on how to donate, as well as credits, changelog,
ECHO and other information can all be found on my website:
ECHO https://tikolu.net/world-exporter
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT
