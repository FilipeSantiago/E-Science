@ECHO OFF

call PSLoadExecutable.bat IsMatchCSVFileColumnNames -o IsMatchCSVFileColumnNamesOutput_%1 -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR
