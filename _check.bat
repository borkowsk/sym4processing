@echo off
echo Running "%0" in  "%cd%"
echo --------------------------------------------------------------------
     
echo Testing for required software: 
echo ------------------------------
echo ===
echo Searching for Processing...

dir /S /B %USERPROFILE%\processing.exe > processing_dirs.lst
more processing_dirs.lst
find /C "processing.exe" processing_dirs.lst
if ERRORLEVEL 1 goto BRAKPROCESSINGU
echo ----------------------------------------------
echo Looks like you have Processing.
echo Remember to run install in its main directory.
echo ----------------------------------------------

echo ===
echo Searching for Hamoid Video...
dir /S /B %USERPROFILE%\hamoid* > hamolib_dirs.lst
more hamolib_dirs.lst
find /C "hamoid" hamolib_dirs.lst
if ERRORLEVEL 1 goto BRAKHAMOID
echo ------------------------------------------------------
echo Looks like you have hamoid library instaled.
echo If you have troubles with configuration,
echo delete Processing\libraries\VideoExport\settings.json
echo ------------------------------------------------------
echo ===
echo Searching for ffmpeg tool...
dir /S /B %USERPROFILE%\ffmpeg.exe "C:\Program Files\ffmpeg.exe" "C:\Program Files (x86)\ffmpeg.exe" > ffmpg_dirs.lst
more ffmpg_dirs.lst
find /C "ffmpeg" ffmpg_dirs.lst
if ERRORLEVEL 1 goto BRAKFFMPEG
echo ----------------------------------------------
echo Looks like you have ffmpeg tool instaled.
echo ----------------------------------------------

goto KONIEC

:BRAKPROCESSINGU
echo You have to install Processing!
start http:\\www.processing.org\
goto KONIEC

:BRAKHAMOID
echo You have to install Hamoid library into Processing! 
goto KONIEC

:BRAKFFMPEG
echo You have to install ffmpeg tool!
start http:\\ffmpeg.org
goto KONIEC

:KONIEC

