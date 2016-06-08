@echo off

call PSLoadExecutable.bat UpdateComputedColumns -o IsUpdatedComputedColumnsOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
echo .\IsMatchTableRowCount.bat %1
IF NOT ERRORLEVEL 0 GOTO ENDERR
