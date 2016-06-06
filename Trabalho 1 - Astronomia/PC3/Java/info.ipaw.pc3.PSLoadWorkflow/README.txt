cd C:\PC3\Java

ant jar

ant runJ062941
ant runJ062942
ant runJ062943
ant runJ062944
ant runJ062945

ant derbyShell (or .\derby_shell.bat)

-- Derby Shell commands -- 
CONNECT 'jdbc:derby:;databaseName=J062941_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

CONNECT 'jdbc:derby:;databaseName=J062942_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

CONNECT 'jdbc:derby:;databaseName=J062943_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

CONNECT 'jdbc:derby:;databaseName=J062944_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

CONNECT 'jdbc:derby:;databaseName=J062945_LoadDB;user=ipaw;password=pc3_load-2009';
SELECT COUNT(*) FROM P2Detection; 

QUIT;