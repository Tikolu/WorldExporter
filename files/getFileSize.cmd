@ECHO OFF

:: Minecraft PE Internal World Exporter (file size checker)
::
:: Created by Tikolu - http://tikolu.net16.net
:: Report issues to tikolu43@gmail.com

IF [%1]==[] (
	ECHO To use the World Exporter, run exporter.cmd from the root folder.
	ECHO Press enter to exit.
	PAUSE>NUL
	EXIT /B
)
ECHO %~z1
EXIT /B