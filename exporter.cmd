:: Minecraft PE Internal World Exporter
:: Version 2.5
::
:: Created by Tikolu - https://tikolu.net/worldExporter
:: Report issues to tikolu43@gmail.com


:SETUP
@ECHO OFF
TITLE MCPE Internal World Exporter tool by Tikolu - Version 2.5
COLOR 0f
CD %~dp0
SET heading=Internal World Exporter by Tikolu
SET divider==================================
SET email=tikolu43@gmail.com
IF NOT EXIST files\temp GOTO FILEERROR
CD files
ECHO test>temp
SET /p test=<temp
IF NOT [%test%]==[test] GOTO FILEERROR
WHERE java >nul 2>nul
IF %errorlevel%==1 GOTO JAVANOTINSTALLED
IF EXIST "..\minecraftWorlds" GOTO WORLDFOLDEREXISTS
CLS
ECHO Launching ADB...
adb0 start-server>nul
ECHO Getting device state...
adb0 get-state>temp
SET /p deviceState=<temp
IF [%deviceState%]==[device] GOTO BACKUP
GOTO INTRODUCTION

:FILEERROR
CLS
ECHO An error was encountered when trying to access the files folder.
ECHO Please make sure that the ZIP file is extracted before using World Exporter.
ECHO If you need help, please contact %email%
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:JAVANOTINSTALLED
CLS
ECHO Java was not detected on your system.
ECHO Please make sure Java is installed.
ECHO If you need help, please contact %email%
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
PAUSE>NUL
EXIT

:BACKUPERROR
CLS
ECHO Something went wrong during the extraction process.
ECHO.
ECHO But don't give up yet!
ECHO This might be due to a few different reasons, so email me and I will respond as soon as possible.
ECHO My email: %email%
PAUSE>NUL
EXIT

:EMPTYBACKUP
CLS
ECHO The backup has been exported succesfully but the minecraftWorlds folder could not be found.
ECHO Are you sure that you have set your storage type to "Application" in Minecraft settings?
ECHO If you need help, please contact %email%
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:INTRODUCTION
CLS
ECHO Welcome to Internal World Exporter
ECHO ==================================
ECHO.
ECHO You can use this tool to export worlds from Minecraft Pocket Edition if you have set
ECHO your storage type to "Application" in the settings.
ECHO.
ECHO This program was created by Tikolu. If you experience any problems during the
ECHO process, please contact me at %email%. Documentation: tikolu.net/worldExporter
ECHO.
ECHO Whenever you're ready, press enter.
PAUSE>NUL
GOTO DRIVER

:DRIVER
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO An ADB driver is required to connect to the device. It will now get installed.
ECHO.
ECHO After pressing enter, a popup will appear. Do the following:
ECHO 1. Click "Yes" on the orange popup.
ECHO 2. Click "Next" in the driver installation window.
ECHO 3. Wait for the driver to install. Click "Yes" on all popups.
ECHO 4. After the driver is installed, click on "Finish" to close the window.
ECHO.
ECHO Press enter whenever you're ready to install the drivers.
PAUSE>NUL
CD driver
CALL installer install
CD ..
ECHO Press enter if the drivers were succesfully installed.
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
ECHO 7. After connecting a popup will ask "Allow USB Debugging?". Tap on "Ok".
ECHO.
ECHO The World Extraction will start as soon as you Tap "Ok" on your device.
adb0 wait-for-device
GOTO BACKUP

:BACKUP
adb0 shell pm path com.mojang.minecraftpe>temp
SET /p minecraftPath=<temp
IF [%minecraftPath%]==[] GOTO MINECRAFTNOTINSTALLED
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO A backup request has been sent to your device. This will get Minecraft's data and move it to your computer.
ECHO.
ECHO Please tap on "Back up my data" to begin the backup procedure.
ECHO This might take a few minutes, depending on how many worlds you have.
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
CD backup\apps\com.mojang.minecraftpe\r\games\com.mojang
IF EXIST "%~dp0\minecraftWorlds" GOTO WORLDFOLDEREXISTS
MOVE "minecraftWorlds" "%~dp0">NUL
ECHO Cleaning up...
CD "..\..\..\..\..\.."
RMDIR backup /s /q
IF EXIST "backup.ab" DEL backup.ab
IF EXIST "backup.tar" DEL backup.tar
adb0 kill-server>nul
ECHO World Export Complete!
TIMEOUT /T 2 >NUL
START %~dp0\minecraftWorlds
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
ECHO and other information can be found on my website:
ECHO https://tikolu.net/worldExporter
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT
