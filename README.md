# MINECRAFT POCKET EDITION WORLD EXPORTER
Created by Tikolu - tikolu.net16.net
Current version: 2.2

---

Minecraft Pocket Edition gives the player a choice of where their worlds should be kept. "External" saves Worlds in the device storage where the user can easily transfer them to another device. "Application" stores the Worlds internally in Minecraft’s private folder to which you have no access. Many people believe that rooting your device is the only method of exporting the worlds. However, this is not true!
You can use this program to export worlds from Minecraft Pocket Edition if your "Storage Type" is set to "Application" in Minecraft Settings. The whole process is very simple and can be finished in under five minutes. Your device does NOT need to be rooted!

---

#### YOU WILL NEED

An Android device with Minecraft PE installed
Your "Storage Type" to be set to "Application"
A computer running Windows 7 or newer
Java Installed on the Computer
A USB Cable to connect to your device
About five minutes and some patience

#### HOW DOES IT WORK

The program utilizes ADB’s backup feature which allows for copying an applications data even without root privileges. However, the exported backup file is encrypted so Android Backup Extractor is used to extract its contents into a tar archive. 7zip is then used to unarchive the tar file, and finally, the minecraftWorlds folder is moved to the desktop.


The only user interaction required is the installation of the Android driver and enabling USB Debugging in Android Settings. Instructions for doing both of these tasks are included in the program.


The code for the program is available here.


#### DOWNLOAD

The latest version can be downloaded from:

My website
GitHub or
Google Drive
The ZIP file is 16.6MB in size.


After downloading, first open and extract the ZIP file, then run “exporter.cmd”.


Java needs to be installed for World Exporter to function. Java can be downloaded from here.


#### CONTACT

Please feel free to contact me through email or Hangouts if:

My program helped you
You ran into an error while using my program
You couldn’t get your device to connect
There is a feature you would like to see added
You have questions about the program
Anything else... 
My email address is tikolu43@gmail.com.


#### CREDITS

- MCPE Internal World Exporter

  Created by Tikolu (documentation)


- Help and error testing

  Provided by Cory Rankin (github)

 

- Android Debug Bridge

  Created by Google (download)


- Google USB Driver

  Created by Google (download)


- Android Backup Extractor

  Created by Nikolay Elenkov (github)


- 7zip

  Created by Igor Pavlov (website)


- Java Runtime

  Created by Oracle (website)


#### CHANGELOG
Version 2.2

Fixed a bug which caused files to be inaccessible when running World Exporter with administrator privileges
All 7zip DLLs will now be included in the files folder
Version 2.1

Changes to all error messages
Ignoring the "Minecraft Not Installed" error is no longer an option
Some unnecessary confirmation messages will no longer be shown during world extraction
Download now also available from Tikolu website
Version 2.0

Project will now be available on GitHub
Added diagnostic Terminal tool in files folder
Errors no longer have red text
The program will now offer to delete the world folder from the desktop if a conflict is detected
Changes to the "Minecraft Not Installed" error message
The "Backup Error" message will now be more friendly
The worlds folder will automatically open after extraction
Messages displayed during the extraction process will make more sense
The user will now be informed when they can disconnect their device
Added Cory Rankin to the credits (Thanks a lot, Cory)
Version 1.7

Java Runtime will no longer be included in the program
An error will now display if Java is not installed
A message will be displayed while ADB is initializing
Self extracting EXE archives will no longer be available (too problematic)
Version 1.6

The default download method will now be ZIP because self extracting EXE archives were too problematic
A few ADB related bugs have been fixed
Version 1.5

World Exporter will now check for necessary files before download.
Version 1.4

Added option to skip Minecraft installation check for devices which do not respond to ADB’s path command correctly
Version 1.3

Added error message when attempting to export worlds from an empty Minecraft backup
Program will now check if the minecraftWorlds folder exists before attempting to move it to the Desktop
Added links to documentation inside the program
Documentation will now open instead of the credits
Version 1.2

Instructions will skip if program detects already connected device
Extraction will cancel if a worlds folder already exists on desktop to avoid errors
Program will check if Minecraft is present on the device before initiating extraction
Program will now detect if backup was cancelled by the user or if a Desktop Backup Password was incorrectly entered
Version 1.1

Simplified included instructions
Fixed various grammar and spelling mistakes
Steps which were unnecessarily divided were joined up
Version 1.0

Original Release
