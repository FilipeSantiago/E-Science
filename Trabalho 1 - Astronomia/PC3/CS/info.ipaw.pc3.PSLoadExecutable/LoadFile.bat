@ECHO OFF

ECHO /////////////////////////////////////
ECHO //////   Pre Load Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.a. IsExistsCSVFile
info.ipaw.pc3.PSLoadExecutable.exe IsExistsCSVFile -o IsExistsCSVFileOutput_%1 -f %1
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.b. Control Flow: Decision
TYPE IsExistsCSVFileOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.c. ReadCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_%1 -f %1
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.d. IsMatchCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe IsMatchCSVFileColumnNames -o IsMatchCSVFileColumnNamesOutput_%1 -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.e. Control Flow: Decision
TYPE IsMatchCSVFileColumnNamesOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////        Load File        //////
ECHO /////////////////////////////////////

ECHO // 7.f. LoadCSVFileIntoTable
info.ipaw.pc3.PSLoadExecutable.exe LoadCSVFileIntoTable -o IsLoadedCSVFileIntoTableOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.g. Control Flow: Decision
TYPE IsLoadedCSVFileIntoTableOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.h. UpdateComputedColumns
info.ipaw.pc3.PSLoadExecutable.exe UpdateComputedColumns -o IsUpdatedComputedColumnsOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.i. Control Flow: Decision
TYPE IsUpdatedComputedColumnsOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////   PostLoad Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.j. IsMatchTableRowCount
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableRowCount -o IsMatchTableRowCountOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.k. Control Flow: Decision	
TYPE IsMatchTableRowCountOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.l. IsMatchTableColumnRanges
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableColumnRanges -o IsMatchTableColumnRangesOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.m. Control Flow: Decision
TYPE IsMatchTableColumnRangesOutput_%1 | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO ////////    FILE SUCCESS     ////////
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GOTO DONE

:ENDERR
ECHO xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ECHO ////////     FILE FAILED     ////////
ECHO xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

:DONE