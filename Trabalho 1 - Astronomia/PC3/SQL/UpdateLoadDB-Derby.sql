CONNECT 'jdbc:derby:;databaseName=J000001_LoadDB;user=ipaw;password=pc3-CAiSE2009';

-- LoadCSVFileIntoTable
CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE (null,'P2DETECTION','C:\PC3\SampleData\J062941\P2_J062941_B001_P2fits0_20081115_P2Detection.csv',',',null,null,0);

CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE (null,'P2FRAMEMETA','C:\PC3\SampleData\J062941\P2_J062941_B001_P2fits0_20081115_P2FrameMeta.csv',',',null,null,0);

CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE (null,'P2IMAGEMETA','C:\PC3\SampleData\J062941\P2_J062941_B001_P2fits0_20081115_P2ImageMeta.csv',',',null,null,0);


-- UpdateComputedColumns
UPDATE P2Detection SET zoneID = ("dec"+(90.0))/(0.0083333);

UPDATE P2Detection SET cx = (COS(RADIANS("dec"))*COS(RADIANS(ra)));

UPDATE P2Detection SET cy = COS(RADIANS("dec"))*SIN(RADIANS(ra));

UPDATE P2Detection SET cz = (SIN(RADIANS("dec")));


-- IsMatchTableRowCount
SELECT COUNT(*) FROM P2Detection;

SELECT COUNT(*) FROM P2FrameMeta;

SELECT COUNT(*) FROM P2ImageMeta;


-- IsMatchTableColumnRanges
SELECT COUNT(*) FROM P2Detection WHERE (ra < 0 OR ra > 360) AND ra != -999;

SELECT COUNT(*) FROM P2Detection WHERE ("dec" < -90 OR "dec" > 90) AND "dec" != -999;

SELECT COUNT(*) FROM P2Detection WHERE (raErr < -2000 OR raErr > 9) AND raErr != -999;

SELECT COUNT(*) FROM P2Detection WHERE (decErr < 0 OR decErr > 9) AND decErr != -999;


-- CompactDatabase
CALL SYSCS_UTIL.SYSCS_INPLACE_COMPRESS_TABLE('IPAW', 'P2DETECTION', 1, 1, 1);
CALL SYSCS_UTIL.SYSCS_INPLACE_COMPRESS_TABLE('IPAW', 'P2FRAMEMETA', 1, 1, 1);
CALL SYSCS_UTIL.SYSCS_INPLACE_COMPRESS_TABLE('IPAW', 'P2IMAGEMETA', 1, 1, 1);

CONNECT 'jdbc:derby:;databaseName=J000001_LoadDB;shutdown=true;user=ipaw;password=pc3-CAiSE2009';