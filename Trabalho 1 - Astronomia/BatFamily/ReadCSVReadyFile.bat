@ECHO OFF

SET CSVROOTPATH_INPUT=%1

call PSLoadExecutable.bat ReadCSVReadyFile -o ReadCSVReadyFileOutput.xml -f %CSVROOTPATH_INPUT%
echo .\IsMatchCSVFileColumnNames.bat %CSVROOTPATH_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

:DONE
