CD C:\PC3\CS\info.ipaw.pc3.PSLoadExecutable

REM Run
MKDIR tmp
COPY bin\* tmp
COPY *.bat tmp
COPY Sample\in\*.xml tmp
CD tmp
.\LoadWorkflow.bat .\JobIDInput.xml .\CSVRootPathInput.xml

REM Test
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062941_LoadDB.dbo.P2Detection; "

