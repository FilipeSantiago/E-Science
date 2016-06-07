call PSLoadExecutable.bat IsMatchTableColumnRanges -o IsMatchTableColumnRangesOutput_%1 -f CreateEmptyLoadDBOutput.xml -f ReadCSVFileColumnNamesOutput_%1
IF NOT ERRORLEVEL 0 GOTO ENDERR