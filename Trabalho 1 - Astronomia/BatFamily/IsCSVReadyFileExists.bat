@ECHO OFF

SET CSVROOTPATH_INPUT=%1

call PSLoadExecutable.bat IsCSVReadyFileExists -o IsCSVReadyFileExistsOutput.xml -f %CSVROOTPATH_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

TYPE IsCSVReadyFileExistsOutput.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

:DONE