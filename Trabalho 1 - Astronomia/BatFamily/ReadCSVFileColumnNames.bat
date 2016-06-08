@ECHO OFF

call PSLoadExecutable.bat ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_%1 -f %1
IF NOT ERRORLEVEL 0 GOTO ENDERR
