call PSLoadExecutable.bat SplitList -o FileEntry?.xml -f ReadCSVReadyFileOutput.xml
IF NOT ERRORLEVEL 0 GOTO ENDERR
