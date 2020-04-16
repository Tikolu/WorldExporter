@ECHO OFF

:: Minecraft PE World Exporter (diagnostic terminal)
::
:: Created by Tikolu - http://tikolu.net
:: Report issues to tikolu43@gmail.com

TITLE Minecraft PE World Exporter - Terminal
ECHO This Terminal is for diagnostic purposes only.
ECHO To use the World Exporter, run exporter.cmd from the root folder.
:LOOP
ECHO.
SET /p input="%CD%>"
%input%
GOTO LOOP
