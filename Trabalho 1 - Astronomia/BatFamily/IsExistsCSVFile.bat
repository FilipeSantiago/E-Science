@echo off

call PSLoadExecutable.bat IsExistsCSVFile -o IsExistsCSVFileOutput_%1 -f %1
echo .\ReadCSVFileColumnNames.bat %1
IF NOT ERRORLEVEL 0 GOTO ENDERR
