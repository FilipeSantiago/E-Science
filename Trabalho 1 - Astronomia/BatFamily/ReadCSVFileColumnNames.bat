@ECHO OFF

call PSLoadExecutable.bat ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_%1 -f %1
echo .\IsMatchCSVFileColumnNames.bat %1
IF NOT ERRORLEVEL 0 GOTO ENDERR
