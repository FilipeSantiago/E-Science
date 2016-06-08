@ECHO OFF

call PSLoadExecutable.bat IsMatchCSVFileTables -o IsMatchCSVFileTablesOutput.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

TYPE IsMatchCSVFileTablesOutput.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

:DONE
