using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;

namespace info.ipaw.pc3.PSLoadWorkflow {

  public class LoadAppLogic {

    #region Database Constants
    private const string SQL_SERVER = "localhost\\SQLEXPRESS";
    private const string SQL_USER = "IPAW";
    private const string SQL_PASSWORD = "pc3_load-2009";
    #endregion

    #region Helper data structures
    [Serializable]
    public class CSVFileEntry {
      public string FilePath;
      public string HeaderPath;
      public int RowCount;
      public string TargetTable;
      public string Checksum;
      public List<string> ColumnNames;
    }

    [Serializable]
    public class DatabaseEntry {
      public string DBGuid;
      public string DBName;
      public string ConnectionString;
    }
    #endregion

    #region Pre-Load Sanity Checks

    /// <summary>
    /// Checks if the CSV Ready File exists in the given rooth path to the CSV Batch
    /// </summary>
    /// <param name="CSVRootPath">Path to the root directory for the batch</param>
    /// <returns>true if the csv_ready.csv file exists in the CSVRoothPath. False otherwise.</returns>
    public static bool IsCSVReadyFileExists(string CSVRootPath) {
      
      // 1. Check if parent directory exists.
      DirectoryInfo RootDirInfo = new DirectoryInfo(CSVRootPath);
      if (!RootDirInfo.Exists) return false;

      // 2. Check if CSV Ready file exists. We assume a static name for the ready file.
      string CSVReadyFilePath = Path.Combine(CSVRootPath, "csv_ready.csv");
      FileInfo ReadyFileInfo = new FileInfo(CSVReadyFilePath);
      return ReadyFileInfo.Exists;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="CSVRootPath"></param>
    /// <returns></returns>
    public static List<CSVFileEntry> ReadCSVReadyFile (string CSVRootPath) {

      // 1. Initialize output list of file entries
      List<CSVFileEntry> CSVFileEntryList = new List<CSVFileEntry>();
      
      // 2. Open input stream to read from CSV Ready File
      string CSVReadyFilePath       =  Path.Combine(CSVRootPath, "csv_ready.csv");
      StreamReader ReadyFileStream  = new StreamReader(CSVReadyFilePath);

      // 3. Read each line in CSV Ready file and split the lines into 
      //    individual columns separated by commas
      string ReadyFileLine;
      while ((ReadyFileLine = ReadyFileStream.ReadLine()) != null) {
        
        // 3.a. Expect each line in the CSV ready file to be of the format:
        // <FileName>,<NumRows>,<TargetTable>,<MD5Checksum>        
        string[] ReadyFileLineTokens = ReadyFileLine.Split(',');
        
        // 3.b. Create an empty FileEntry and populate it with the columns
        CSVFileEntry FileEntry  = new CSVFileEntry();
        FileEntry.FilePath      = Path.Combine(CSVRootPath, ReadyFileLineTokens[0].Trim()); // column 1
        FileEntry.HeaderPath    = FileEntry.FilePath + ".hdr";
        FileEntry.RowCount      = int.Parse(ReadyFileLineTokens[1].Trim()); // column 2
        FileEntry.TargetTable   = ReadyFileLineTokens[2].Trim(); // column 3
        FileEntry.Checksum      = ReadyFileLineTokens[3].Trim(); // column 4

        // 3.c. Add file entry to output list
        CSVFileEntryList.Add(FileEntry);
      }

      // 4. Close input stream and return output file entry list
      ReadyFileStream.Close();
      return CSVFileEntryList;
    }
    
    /// <summary>
    /// Check if the correct list of files/table names are present in this batch
    /// </summary>
    /// <param name="FileEntries"></param>
    /// <returns></returns>
    public static bool IsMatchCSVFileTables(List<CSVFileEntry> FileEntries) {

      // check if the file count and the expected number of tables match
      if (LoadConstants.EXPECTED_TABLES.Count != FileEntries.Count) return false;

      // for each expected table name, check if it is present in the list of file entries
      foreach (string TableName in LoadConstants.EXPECTED_TABLES) {
        bool TableExists = false;
        foreach (CSVFileEntry FileEntry in FileEntries) {
          if(!TableName.Equals(FileEntry.TargetTable)) continue;
          TableExists = true; // found a match
          break;
        }
        // if the table name did not exist in list of CSV files, this check fails.
        if (!TableExists) return false;
      }

      return true;
    }

    /// <summary>
    /// Test if a CSV File defined in the CSV Ready list actually exists on disk.
    /// </summary>
    /// <param name="FileEntry">FileEntry for CSVFile to test</param>
    /// <returns>True if the FilePath in the given FileEntry exists on disk. False otherwise.</returns>
    public static bool IsExistsCSVFile(CSVFileEntry FileEntry) {
      FileInfo CSVFileInfo = new FileInfo(FileEntry.FilePath);
      if(!CSVFileInfo.Exists) return false;

      FileInfo CSVFileHeaderInfo = new FileInfo(FileEntry.HeaderPath);
      return CSVFileHeaderInfo.Exists;        
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="FileEntry"></param>
    /// <param name="FileEntry"></param>
    /// <returns></returns>
    public static CSVFileEntry ReadCSVFileColumnNames (CSVFileEntry FileEntry) {

      // 2. Read the header line of the CSV File.
      StreamReader CSVFileReader = new StreamReader(FileEntry.HeaderPath);
      string HeaderRow = CSVFileReader.ReadLine();

      // 3. Extract the comma-separated columns names of the CSV File from its header line.
      // Strip empty spaces around column names.
      List<string> ColumnNames = new List<string>(HeaderRow.Split(','));
      FileEntry.ColumnNames = new List<string>();
      foreach (string ColumnName in ColumnNames) 
        FileEntry.ColumnNames.Add(ColumnName.Trim());

      CSVFileReader.Close();

      return FileEntry;
    }

    /// <summary>
    /// Checks if the correct list of column headers is present for the CSV file
    /// to match the table
    /// </summary>
    /// <param name="FileEntry">FileEntry for CSV File whose column headers to test</param>
    /// <returns>True if the column headers present in the CSV File are the same as the 
    /// expected table columns. False otherwise.</returns>
    public static bool IsMatchCSVFileColumnNames (CSVFileEntry FileEntry) {
      
      // determine expected columns
      List<string> ExpectedColumns = null;
      switch(FileEntry.TargetTable.ToUpper()) {
        case "P2DETECTION":
          ExpectedColumns = LoadConstants.EXPECTED_DETECTION_COLS;
          break;
        case "P2FRAMEMETA":
          ExpectedColumns = LoadConstants.EXPECTED_FRAME_META_COLS;
          break;
        case "P2IMAGEMETA":
          ExpectedColumns = LoadConstants.EXPECTED_IMAGE_META_COLS;
          break;
        default:
          // none of the table types match...invalid
          return false;
      }

      // test if the expected and present column name counts are the same
      if (ExpectedColumns.Count != FileEntry.ColumnNames.Count) return false;

      // test of all expected names exist in the columns present
      foreach(string ColumnName in ExpectedColumns) {
        if (!FileEntry.ColumnNames.Contains(ColumnName)) 
          return false; // mismatch
      }

      // all columns match
      return true;
    }

    #endregion

    #region Loading Section
    /// <summary>
    /// 
    /// </summary>
    /// <param name="JobID"></param>
    /// <returns></returns>
    public static DatabaseEntry CreateEmptyLoadDB (string JobID) {
      
      // initialize database entry for storing database properties
      DatabaseEntry DBEntry = new DatabaseEntry();
      DBEntry.DBName = JobID + "_LoadDB";
      DBEntry.DBGuid = Guid.NewGuid().ToString();
      
      // initialize Sql Connection String to sql server
      SqlConnectionStringBuilder ConnStr = new SqlConnectionStringBuilder();
      ConnStr.DataSource = SQL_SERVER;
      ConnStr.UserID = SQL_USER;
      ConnStr.Password = SQL_PASSWORD;

      // Create empty database instance
      using(SqlConnection SqlConn = new SqlConnection(ConnStr.ToString())) {
        string SqlStr = "CREATE DATABASE " + DBEntry.DBName;
        SqlConn.Open();
        SqlCommand SqlCmd = new SqlCommand(SqlStr, SqlConn);
        SqlCmd.ExecuteNonQuery();
        SqlConn.Close();
      }

      // update Sql Connection String to new create tables
      ConnStr.InitialCatalog = DBEntry.DBName;
      DBEntry.ConnectionString = ConnStr.ToString();
      using (SqlConnection SqlConn = new SqlConnection(ConnStr.ToString())) {
        SqlConn.Open();
        // Create P2 Table
        SqlCommand SqlCmd = new SqlCommand(LoadSql.CREATE_DETECTION_TABLE, SqlConn);
        SqlCmd.ExecuteNonQuery();
        // Create P2FrameMeta Table
        SqlCmd = new SqlCommand(LoadSql.CREATE_FRAME_META_TABLE, SqlConn);
        SqlCmd.ExecuteNonQuery();
        // Create P2ImageMeta Table
        SqlCmd = new SqlCommand(LoadSql.CREATE_IMAGE_META_TABLE, SqlConn);
        SqlCmd.ExecuteNonQuery();
        SqlConn.Close();
      }

      return DBEntry;
    }

    // derby bulk load: SYSCS_UTIL.SYSCS_IMPORT_TABLE
    /// <summary>
    /// Loads a CSV File into an existing table using Sql BULK INSERT command
    /// </summary>
    /// <param name="DBEntry">Database into which to load the CSV file</param>
    /// <param name="FileEntry">File to be bulk loaded into database table</param>
    /// <returns>True if the bulk load ran without exceptions. False otherwise.</returns>
    public static bool LoadCSVFileIntoTable(DatabaseEntry DBEntry, CSVFileEntry FileEntry) {
      try {        
        // connect to database instance
        using (SqlConnection SqlConn = new SqlConnection(DBEntry.ConnectionString)) {
          // build bulk insert SQL command
          string SqlStr = string.Format(
              @"BULK INSERT {0} FROM '{1}'
              WITH(BATCHSIZE=10000, CODEPAGE='raw', FIELDTERMINATOR=',',
              FIRSTROW=1, MAXERRORS=0, ROWTERMINATOR='0x0A', TABLOCK )",
              FileEntry.TargetTable, FileEntry.FilePath);
          // execute bulk insert command
          SqlConn.Open();
          SqlCommand SqlCmd = new SqlCommand(SqlStr, SqlConn);
          SqlCmd.ExecuteNonQuery();
          SqlConn.Close();
        }
      } catch (Exception ex) {
        // bulk insert failed
        return false;
      }
      // bulk insert success
      return true;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="DBEntry"></param>
    /// <param name="FileEntry"></param>
    public static bool UpdateComputedColumns(DatabaseEntry DBEntry, CSVFileEntry FileEntry) {
      
      try {
        using (SqlConnection SqlConn = new SqlConnection(DBEntry.ConnectionString)) {          

          switch (FileEntry.TargetTable.ToUpper()) {
            case "P2DETECTION":
              // Update ZoneID
              SqlConn.Open();
              SqlCommand SqlCmd = 
                new SqlCommand(@"UPDATE P2Detection SET zoneID = (""dec""+(90.0))/(0.0083333)", SqlConn);
              SqlCmd.ExecuteNonQuery();
              SqlConn.Close();

              // Update cx
              SqlConn.Open();
              SqlCmd =
                new SqlCommand(@"UPDATE P2Detection SET cx = (COS(RADIANS(""dec""))*COS(RADIANS(ra)))", SqlConn);
              SqlCmd.ExecuteNonQuery();
              SqlConn.Close();
              
              // Update cy
              SqlConn.Open();
              SqlCmd =
                new SqlCommand(@"UPDATE P2Detection SET cy = COS(RADIANS(""dec""))*SIN(RADIANS(ra))", SqlConn);
              SqlCmd.ExecuteNonQuery();
              SqlConn.Close();
              
              // Update cz
              SqlConn.Open();
              SqlCmd =
                new SqlCommand(@"UPDATE P2Detection SET cz = (SIN(RADIANS(""dec"")))", SqlConn);
              SqlCmd.ExecuteNonQuery();
              SqlConn.Close();

              break;

            case "P2FRAMEMETA":
              // No columns to be updated for FrameMeta
              break;
            case "P2IMAGEMETA":
              // No columns to be updated for ImageMeta
              break;
            default:
              // none of the table types matches...invalid
              return false;
          }          
        }
      } catch (Exception ex) {
        // update column failed
        return false;
      }
      // update column success
      return true;      
    }
    #endregion

    #region Post-Load Checks
    /// <summary>
    /// 
    /// </summary>
    /// <param name="DBEntry"></param>
    /// <param name="FileEntry"></param>
    /// <returns></returns>
    public static bool IsMatchTableRowCount (DatabaseEntry DBEntry, CSVFileEntry FileEntry) {
      // does the number of rows expected match the number of rows loaded
      using (SqlConnection SqlConn = new SqlConnection(DBEntry.ConnectionString)) {
        // build row count command
        string SqlStr = "SELECT COUNT(*) FROM " + FileEntry.TargetTable;
        // execute row count command
        SqlConn.Open();
        SqlCommand SqlCmd = new SqlCommand(SqlStr, SqlConn);
        int RowCount = (int)SqlCmd.ExecuteScalar();
        SqlConn.Close();
        // check if row count matches expected row count
        return RowCount == FileEntry.RowCount;
      }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="DBEntry"></param>
    /// <param name="FileEntry"></param>
    /// <returns></returns>
    public static bool IsMatchTableColumnRanges (DatabaseEntry DBEntry, CSVFileEntry FileEntry) {
      
      // determine expected column ranges
      List<LoadConstants.ColumnRange> ExpectedColumnRanges = null;
      switch(FileEntry.TargetTable.ToUpper()) {
        case "P2DETECTION":
          ExpectedColumnRanges = LoadConstants.EXPECTED_DETECTION_COL_RANGES;
          break;
        case "P2FRAMEMETA":
          // No columns range values available for FrameMeta
          ExpectedColumnRanges = new List<LoadConstants.ColumnRange>();
          break;
        case "P2IMAGEMETA":
          // No columns range values available for ImageMeta
          ExpectedColumnRanges = new List<LoadConstants.ColumnRange>(); 
          break;
        default:
          // none of the table types matches...invalid
          return false;
      }

      // connect to database instance
      using (SqlConnection SqlConn = new SqlConnection(DBEntry.ConnectionString)) {
        
        // For each column in available list, test if rows in table fall outside expected range
        foreach (LoadConstants.ColumnRange Column in ExpectedColumnRanges) {

          // build SQL command for error count
          string SqlStr =
              string.Format(@"SELECT COUNT(*) FROM {0} WHERE ({1} < {2} OR {1} > {3}) AND {1} != -999",
                            FileEntry.TargetTable, Column.ColumnName,
                            Column.MinValue, Column.MaxValue);

          // execute range error count command
          SqlConn.Open();
          SqlCommand SqlCmd = new SqlCommand(SqlStr, SqlConn);
          int ErrorCount = (int)SqlCmd.ExecuteScalar();
          SqlConn.Close();
          if (ErrorCount > 0) return false; // found a range error
        }
      }

      return true; // no range errors found
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="DBEntry"></param>
    public static void CompactDatabase(DatabaseEntry DBEntry) {
      // Shrink database instance
      using (SqlConnection SqlConn = new SqlConnection(DBEntry.ConnectionString)) {
        string SqlStr = string.Format("DBCC SHRINKDATABASE ({0})", DBEntry.DBName);
        SqlConn.Open();
        SqlCommand SqlCmd = new SqlCommand(SqlStr, SqlConn);
        SqlCmd.ExecuteNonQuery();
        SqlConn.Close();
      }
    }
    #endregion

  }
}
