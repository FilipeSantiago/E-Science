call PSLoadExecutable.bat CompactDatabase -f CreateEmptyLoadDBOutput.xml
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
