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
ECHO //////   0000000000000000000   //////
ECHO /////////////////////////////////////
ECHO //////   Pre Load Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.a. IsExistsCSVFile
info.ipaw.pc3.PSLoadExecutable.exe IsExistsCSVFile -o IsExistsCSVFileOutput_FileEntry0.xml -f FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.b. Control Flow: Decision
TYPE IsExistsCSVFileOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.c. ReadCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_FileEntry0.xml -f FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.d. IsMatchCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe IsMatchCSVFileColumnNames -o IsMatchCSVFileColumnNamesOutput_FileEntry0.xml -f ReadCSVFileColumnNamesOutput_FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.e. Control Flow: Decision
TYPE IsMatchCSVFileColumnNamesOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////        Load File        //////
ECHO /////////////////////////////////////

ECHO // 7.f. LoadCSVFileIntoTable
info.ipaw.pc3.PSLoadExecutable.exe LoadCSVFileIntoTable -o IsLoadedCSVFileIntoTableOutput_FileEntry0.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.g. Control Flow: Decision
TYPE IsLoadedCSVFileIntoTableOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.h. UpdateComputedColumns
info.ipaw.pc3.PSLoadExecutable.exe UpdateComputedColumns -o IsUpdatedComputedColumnsOutput_FileEntry0.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.i. Control Flow: Decision
TYPE IsUpdatedComputedColumnsOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////   PostLoad Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.j. IsMatchTableRowCount
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableRowCount -o IsMatchTableRowCountOutput_FileEntry0.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.k. Control Flow: Decision	
TYPE IsMatchTableRowCountOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.l. IsMatchTableColumnRanges
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableColumnRanges -o IsMatchTableColumnRangesOutput_FileEntry0.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry0.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.m. Control Flow: Decision
TYPE IsMatchTableColumnRangesOutput_FileEntry0.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO ////////    FILE SUCCESS     ////////
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ECHO /////////////////////////////////////
ECHO //////   1111111111111111111   //////
ECHO /////////////////////////////////////
ECHO //////   Pre Load Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.a. IsExistsCSVFile
info.ipaw.pc3.PSLoadExecutable.exe IsExistsCSVFile -o IsExistsCSVFileOutput_FileEntry1.xml -f FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.b. Control Flow: Decision
TYPE IsExistsCSVFileOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.c. ReadCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_FileEntry1.xml -f FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.d. IsMatchCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe IsMatchCSVFileColumnNames -o IsMatchCSVFileColumnNamesOutput_FileEntry1.xml -f ReadCSVFileColumnNamesOutput_FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.e. Control Flow: Decision
TYPE IsMatchCSVFileColumnNamesOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////        Load File        //////
ECHO /////////////////////////////////////

ECHO // 7.f. LoadCSVFileIntoTable
info.ipaw.pc3.PSLoadExecutable.exe LoadCSVFileIntoTable -o IsLoadedCSVFileIntoTableOutput_FileEntry1.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.g. Control Flow: Decision
TYPE IsLoadedCSVFileIntoTableOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.h. UpdateComputedColumns
info.ipaw.pc3.PSLoadExecutable.exe UpdateComputedColumns -o IsUpdatedComputedColumnsOutput_FileEntry1.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.i. Control Flow: Decision
TYPE IsUpdatedComputedColumnsOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////   PostLoad Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.j. IsMatchTableRowCount
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableRowCount -o IsMatchTableRowCountOutput_FileEntry1.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.k. Control Flow: Decision	
TYPE IsMatchTableRowCountOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.l. IsMatchTableColumnRanges
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableColumnRanges -o IsMatchTableColumnRangesOutput_FileEntry1.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry1.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.m. Control Flow: Decision
TYPE IsMatchTableColumnRangesOutput_FileEntry1.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO ////////    FILE SUCCESS     ////////
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ECHO /////////////////////////////////////
ECHO //////   2222222222222222222   //////
ECHO /////////////////////////////////////
ECHO //////   Pre Load Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.a. IsExistsCSVFile
info.ipaw.pc3.PSLoadExecutable.exe IsExistsCSVFile -o IsExistsCSVFileOutput_FileEntry2.xml -f FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.b. Control Flow: Decision
TYPE IsExistsCSVFileOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.c. ReadCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe ReadCSVFileColumnNames -o ReadCSVFileColumnNamesOutput_FileEntry2.xml -f FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.d. IsMatchCSVFileColumnNames
info.ipaw.pc3.PSLoadExecutable.exe IsMatchCSVFileColumnNames -o IsMatchCSVFileColumnNamesOutput_FileEntry2.xml -f ReadCSVFileColumnNamesOutput_FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.e. Control Flow: Decision
TYPE IsMatchCSVFileColumnNamesOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO /////////////////////////////////////
ECHO //////        Load File        //////
ECHO /////////////////////////////////////

ECHO // 7.f. LoadCSVFileIntoTable
info.ipaw.pc3.PSLoadExecutable.exe LoadCSVFileIntoTable -o IsLoadedCSVFileIntoTableOutput_FileEntry2.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.g. Control Flow: Decision
TYPE IsLoadedCSVFileIntoTableOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.h. UpdateComputedColumns
info.ipaw.pc3.PSLoadExecutable.exe UpdateComputedColumns -o IsUpdatedComputedColumnsOutput_FileEntry2.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.i. Control Flow: Decision
TYPE IsUpdatedComputedColumnsOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR


ECHO /////////////////////////////////////
ECHO //////   PostLoad Validation   //////
ECHO /////////////////////////////////////

ECHO // 7.j. IsMatchTableRowCount
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableRowCount -o IsMatchTableRowCountOutput_FileEntry2.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR

ECHO // 7.k. Control Flow: Decision	
TYPE IsMatchTableRowCountOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO // 7.l. IsMatchTableColumnRanges
info.ipaw.pc3.PSLoadExecutable.exe IsMatchTableColumnRanges -o IsMatchTableColumnRangesOutput_FileEntry2.xml -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_FileEntry2.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
	
ECHO // 7.m. Control Flow: Decision
TYPE IsMatchTableColumnRangesOutput_FileEntry2.xml | FIND /C "false" > NUL
IF NOT ERRORLEVEL 1 GOTO ENDERR

ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO ////////    FILE SUCCESS     ////////
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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