cd C:\PC3\CS\info.ipaw.pc3.PSLoadWorkflow

REM Build
.\build.bat

REM Run
.\run.bat J062941 C:\PC3\SampleData\J062941
.\run.bat J062942 C:\PC3\SampleData\J062942
.\run.bat J062943 C:\PC3\SampleData\J062943
.\run.bat J062944 C:\PC3\SampleData\J062944
.\run.bat J062945 C:\PC3\SampleData\J062945

REM Test
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062941_LoadDB.dbo.P2Detection; "
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062942_LoadDB.dbo.P2Detection; "
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062943_LoadDB.dbo.P2Detection; "
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062944_LoadDB.dbo.P2Detection; "
osql -S localhost\SQLEXPRESS -U ipaw -P pc3_load-2009 -Q "SELECT COUNT(*) FROM J062945_LoadDB.dbo.P2Detection; "

