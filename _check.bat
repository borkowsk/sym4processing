@echo off
echo Running "%0" in  "%cd%"
echo --------------------------------------------------------------------
     
echo Testing for required software: 
echo ------------------------------
echo Searching for Processing...

dir /S /B %USERPROFILE%\processing.exe > processing_dirs.lst
more processing_dirs.lst
find /C "processing.exe" processing_dirs.lst
if ERRORLEVEL 1 goto BRAKPROCESSINGU

echo ----------------------------------------------
echo Looks like you have Processing.
echo Remember to run install in its main directory.
echo ----------------------------------------------
goto KONIEC

:BRAKPROCESSINGU
echo You have to install Processing!
start http:\\www.processing.org\

:KONIEC

