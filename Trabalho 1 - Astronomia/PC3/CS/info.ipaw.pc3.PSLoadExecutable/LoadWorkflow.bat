@ECHO OFF

ECHO /////////////////////////////////////
ECHO //////   Batch Initialization  //////
ECHO /////////////////////////////////////

SET JOBID_INPUT=%1
SET CSVROOTPATH_INPUT=%2

ECHO // 1. IsCSVReadyFileExists
info.ipaw.pc3.PSLoadExecutable.exe IsCSVReadyFileExists -o IsCSVReadyFileExistsOutput.xml -f %CSVROOTPATH_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 2. Control Flow: Decision
TYPE IsCSVReadyFileExistsOutput.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 3. ReadCSVReadyFile
info.ipaw.pc3.PSLoadExecutable.exe ReadCSVReadyFile -o ReadCSVReadyFileOutput.xml -f %CSVROOTPATH_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 4. IsMatchCSVFileTables
info.ipaw.pc3.PSLoadExecutable.exe IsMatchCSVFileTables -o IsMatchCSVFileTablesOutput.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 5. Control Flow: Decision
TYPE IsMatchCSVFileTablesOutput.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 6. CreateEmptyLoadDB
info.ipaw.pc3.PSLoadExecutable.exe CreateEmptyLoadDB -o CreateEmptyLoadDBOutput.xml -f %JOBID_INPUT%
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.x. Split list into component elements
info.ipaw.pc3.PSLoadExecutable.exe SplitList -o FileEntry?.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR


ECHO /////////////////////////////////////
ECHO //////       Do File Load      //////
ECHO /////////////////////////////////////

FOR %%F IN (FileEntry*.xml) DO CALL LoadFile.bat %%F

ECHO /////////////////////////////////////
ECHO //////      Finished Load      //////
ECHO /////////////////////////////////////

ECHO // 8. CompactDatabase
info.ipaw.pc3.PSLoadExecutable.exe CompactDatabase -f CreateEmptyLoadDBOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO //////    FINISHED SUCCESS    ///////
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GOTO DONE

:ENDERR
ECHO xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ECHO ////////   FINISHED FAILED   ////////
ECHO xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

:DONE