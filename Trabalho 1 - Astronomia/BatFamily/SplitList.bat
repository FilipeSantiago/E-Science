

call PSLoadExecutable.bat SplitList -o FileEntry?.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////       Do File Load      //////
ECHO /////////////////////////////////////

FOR %%F IN (FileEntry*.xml) DO CALL LoadFile.bat %%F

ECHO /////////////////////////////////////
ECHO //////      Finished Load      //////
ECHO /////////////////////////////////////

:DONE
