@ECHO OFF

SET JOBID_INPUT=%1

call PSLoadExecutable.bat CreateEmptyLoadDB -o CreateEmptyLoadDBOutput.xml -f %JOBID_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

:DONE
