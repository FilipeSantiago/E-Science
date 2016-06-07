@echo off

call PSLoadExecutable.bat SplitList -o FileEntry?.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

set myvar=
for /r %%i in (FileEntry*.xml) DO call :concat %%i
echo %myvar%
goto :eof

:concat
set myvar=%myvar% %1;
goto :eof
