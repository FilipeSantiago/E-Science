CD C:\PC3\Java

ant jar

MKDIR tmp
COPY info.ipaw.pc3.PSLoadExecutable\*.bat tmp
COPY info.ipaw.pc3.PSLoadExecutable\Sample\in\*.xml tmp
CD tmp
.\LoadWorkflow.bat .\JobIDInput.xml .\CSVRootPathInput.xml

CD C:\PC3\Java
ant derbyShell (or .\derby_shell.bat)

-- Derby Shell commands -- 
CONNECT 'jdbc:derby:;databaseName=tmp\J062941_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

