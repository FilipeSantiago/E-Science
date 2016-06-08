@ECHO OFF

call PSLoadExecutable.bat LoadCSVFileIntoTable -o IsLoadedCSVFileIntoTableOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR
