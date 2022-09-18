#!/bin/bash

# Minecraft PE World Exporter
# Version 2.7
#
# Created by Tikolu - https://tikolu.net/worldExporter
# Report issues to tikolu43@gmail.com

EMAIL="tikolu43@gmail.com"
HEADING="MCPE World Exporter by Tikolu"
DIVIDER="=================================="

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )" # Location of this file

case "$(uname -s)" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE=Linux;;
esac

function setup {
    if [ ! -w "files" ]; then #Test if files folder is writeable
        fileError
    fi

    pushd "files" || fileError
    
    if ! java -jar abe.jar>/dev/null; then
        javaNotInstalled
    fi

    if [ -d "../minecraftWorlds" ]; then
        worldFolderExists
    fi

    if ! command -v adb; then
        adbNotInstalled
    fi
    
    echo Launching ADB...
    adb start-server > /dev/null
    echo Getting device state...
    DEVICESTATE=$(adb get-state)

    if [ "$DEVICESTATE" = "device" ]; then
        backup
    fi
    
    introduction
}

function fileError {
    echo "An error was encountered when trying to access necessary files."
    echo "Please make sure that the ZIP file is extracted before using World Exporter."
    echo "If you need help, please contact $EMAIL"
    echo
    read -p "Press enter to continue"
    exit 1
}

function javaNotInstalled {
    echo "Java was not detected on your system."
    echo "Please make sure Java is installed."
    echo "If you need help, please contact $EMAIL"
    echo
    read -p "Press enter to continue"
    exit 1
}

function worldFolderExists {
    echo "The 'minecraftWorlds' folder inside WorldExporter's directory must be deleted (or renamed) before exporting new worlds."
    echo 
    read -p "Press enter to delete the folder and continue, or Ctrl+C to abort."
    rm -rf "../minecraftWorlds"
    setup
}

function adbNotInstalled {
    echo "This script requires adb. Please install it then run the script again."
    echo
    read -p "Press enter to continue"
    exit 1
}

function minecraftNotInstalled {
    echo "Minecraft was not detected on your device."
    echo "If Minecraft is installed, this means that there is an error communicating with your device. Please contact my email, $EMAIL"
    echo
    read -p "Press enter to continue"
    exit 1
}

function backupError {
    echo "Something went wrong during the extraction process."
    echo
    echo "But don't give up yet!"
    echo "This might be due to a few different reasons, so email me and I will respond as soon as possible."
    echo "My email: $EMAIL"
    read -p "Press enter to continue"
    exit 1
}

function emptyBackup {
    echo "The backup has been exported succesfully but the minecraftWorlds folder could not be found."
    echo "Are you sure that you have set your storage type to 'Application' in Minecraft settings?"
    echo "If you need help, please contact $EMAIL"
    echo
    read -p "Press enter to continue"
    exit 1
}

function introduction {
    echo "Welcome to Minecraft World Exporter"
    echo "==================================="
    echo
    echo "You can use this tool to export worlds from Minecraft Pocket Edition if you have set your storage type to 'Application' in the settings."
    echo
    echo "This program was created by Tikolu. If you experience any problems during the process, please contact me at $EMAIL. Documentation: tikolu.net/worldExporter"
    echo
    echo "Whenever you're ready, press enter."
    read -p "Press enter to continue"
    driver
}

function debugging {
    echo "$HEADING"
    echo "$DIVIDER"
    echo 
    echo "USB Debugging needs to be enabled for this program to connect to your device. Follow these steps:"
    echo 
    echo "1. Go to your Android device settings."
    echo "2. Scroll down to the bottom and click on 'System' and then 'About Device'."
    echo "3. Find 'Build Number' and tap it a few times until you get a message saying 'You are a developer'."
    echo "4. Go out of 'About Device' and back into 'System'. A new 'Developer Options' menu should now be here."
    echo "5. Open it and scroll down to 'USB DEBUGGING'. Make sure that it is ENABLED."
    echo "6. Connect the device to your computer with a USB cable."
    echo "7. After connecting a popup will ask 'Allow USB Debugging?'. Tap on 'Allow'."
    echo
    echo "The World Extraction will start as soon as you Tap 'Allow' on your device."
    adb wait-for-device
    backup
}

function backup {
    MINECRAFTPATH=$(adb shell pm path com.mojang.minecraftpe)
    if [ "$MINECRAFTPATH" = "" ]; then
        minecraftNotInstalled
    fi

    echo "$HEADING"
    echo "$DIVIDER"
    echo
    echo "A backup request has been sent to your device. This will get Minecraft's data and move it to your computer."
    echo
    echo "Please tap on 'Back up my data' to begin the backup procedure."
    echo "This might take a few minutes, depending on how many worlds you have."
    adb backup -noapk com.mojang.minecraftpe > /dev/null
    extraction
}

function extraction {
    echo
    echo "Backup copied from device. You may unplug your device now."
    if [ ! -f "backup.ab" ]; then
        backupError
    fi

    if [ $MACHINE = "Mac" ]; then
        BACKUPSIZE=$(stat -f "%z" "backup.ab")
    elif [ $MACHINE = "Linux" ]; then
        BACKUPSIZE=$(stat --format "%s" "backup.ab")
    fi

    if [ "$BACKUPSIZE" = 0 ]; then
        backupError
    fi
    
    if [ -d "backup" ]; then
        echo "Removing old backup directory"
        rm -rf "backup"
    fi
    mkdir "backup"

    echo "Extracting backup file..."
    java -jar abe.jar unpack backup.ab backup.tar
    if [ ! -f "backup.tar" ]; then
        backupError
    fi

    echo Extracting archive...
    tar -C "./backup" -xf "backup.tar"
    echo "Moving 'minecraftWorlds' folder to WorldExporter directory..."
    
    MINECRAFTDIR="backup/apps/com.mojang.minecraftpe/r/games/com.mojang"
    if [ ! -d "$MINECRAFTDIR" ]; then
        emptyBackup
    fi
    pushd "$MINECRAFTDIR"
    if [ -d "$SCRIPTPATH/minecraftWorlds" ]; then
        worldFolderExists
    fi
    mv "minecraftWorlds" "$SCRIPTPATH"
    
    echo Cleaning up after extraction...
    popd
    
    rm -f "backup.ab" # This won't error if the file doesn't exist, so no need to check for it
    rm -f "backup.tar"
    rm -rf "backup"

    adb kill-server
    echo World Export Complete!
    
    open "$SCRIPTPATH/minecraftWorlds"
    end
}

function end {
    echo "$HEADING"
    echo "$DIVIDER"
    echo
    echo "The worlds have been exported!"
    echo "You should now find a 'minecraftWorlds' folder in the WorldExporter directory."
    echo
    echo "Thank you for using my tool. If it helped you today, please let me know by emailing $EMAIL! If you experienced any issues, errors or if you just have a general suggestion about the program, also let me know!"
    echo
    echo "WorldExporter is (and always will be) a free to use project."
    echo "However, you can support future development of WorldExporter by donating. Any amount will be greatly appreciated!"
    echo
    echo "Information on how to donate, as well as credits, changelog, and other information can all be found on my website:"
    echo "https://tikolu.net/worldExporter"
    echo
    read -p "Press enter to continue"
    exit 0
}

setup