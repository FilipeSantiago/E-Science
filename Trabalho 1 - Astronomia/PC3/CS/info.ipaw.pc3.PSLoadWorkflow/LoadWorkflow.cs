using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace info.ipaw.pc3.PSLoadWorkflow {
  
  public class LoadWorkflow {
    public static void Main(string[] args) {
      string JobID = args[0], CSVRootPath = args[1];

      /////////////////////////////////////
      //////   Batch Initialization  //////
      /////////////////////////////////////
      // 1. IsCSVReadyFileExists
      bool IsCSVReadyFileExistsOutput = LoadAppLogic.IsCSVReadyFileExists(CSVRootPath);
      // 2. Control Flow: Decision
      if (!IsCSVReadyFileExistsOutput) throw new ApplicationException("IsCSVReadyFileExists failed");


      // 3. ReadCSVReadyFile
      List<LoadAppLogic.CSVFileEntry> ReadCSVReadyFileOutput = LoadAppLogic.ReadCSVReadyFile(CSVRootPath);


      // 4. IsMatchCSVFileTables
      bool IsMatchCSVFileTablesOutput = LoadAppLogic.IsMatchCSVFileTables(ReadCSVReadyFileOutput);
      // 5. Control Flow: Decision
      if (!IsMatchCSVFileTablesOutput) throw new ApplicationException("IsMatchCSVFileTables failed");


      // 6. CreateEmptyLoadDB
      LoadAppLogic.DatabaseEntry CreateEmptyLoadDBOutput = LoadAppLogic.CreateEmptyLoadDB(JobID);


      // 7. Control Flow: Loop. ForEach LoadAppLogic.CSVFileEntry in ReadCSVReadyFileOutput Do...
      foreach(LoadAppLogic.CSVFileEntry FileEntry in ReadCSVReadyFileOutput) {
        
        /////////////////////////////////////
        //////   Pre Load Validation   //////
        /////////////////////////////////////
        // 7.a. IsExistsCSVFile
        bool IsExistsCSVFileOutput = LoadAppLogic.IsExistsCSVFile(FileEntry);
        // 7.b. Control Flow: Decision
        if (!IsExistsCSVFileOutput) throw new ApplicationException("IsExistsCSVFile failed");


        // 7.c. ReadCSVFileColumnNames
        LoadAppLogic.CSVFileEntry ReadCSVFileColumnNamesOutput = LoadAppLogic.ReadCSVFileColumnNames(FileEntry);


        // 7.d. IsMatchCSVFileColumnNames
        bool IsMatchCSVFileColumnNamesOutput =
            LoadAppLogic.IsMatchCSVFileColumnNames(ReadCSVFileColumnNamesOutput);
        // 7.e. Control Flow: Decision
        if (!IsMatchCSVFileColumnNamesOutput) throw new ApplicationException("IsMatchCSVFileColumnNames failed");


        /////////////////////////////////////
        //////        Load File        //////
        /////////////////////////////////////
        // 7.f. LoadCSVFileIntoTable
        bool IsLoadedCSVFileIntoTableOutput = 
          LoadAppLogic.LoadCSVFileIntoTable(CreateEmptyLoadDBOutput, ReadCSVFileColumnNamesOutput);
        // 7.g. Control Flow: Decision
        if (!IsLoadedCSVFileIntoTableOutput) throw new ApplicationException("LoadCSVFileIntoTable failed");


        // 7.h. UpdateComputedColumns
        bool IsUpdatedComputedColumnsOutput = 
          LoadAppLogic.UpdateComputedColumns(CreateEmptyLoadDBOutput, ReadCSVFileColumnNamesOutput);
        // 7.i. Control Flow: Decision
        if (!IsUpdatedComputedColumnsOutput) throw new ApplicationException("UpdateComputedColumns failed");


        /////////////////////////////////////
        //////   PostLoad Validation   //////
        /////////////////////////////////////
        // 7.j. IsMatchTableRowCount
        bool IsMatchTableRowCountOutput = 
          LoadAppLogic.IsMatchTableRowCount(CreateEmptyLoadDBOutput, ReadCSVFileColumnNamesOutput);
        // 7.k. Control Flow: Decision
        if (!IsMatchTableRowCountOutput) throw new ApplicationException("IsMatchTableRowCount failed");


        // 7.l. IsMatchTableColumnRanges
        bool IsMatchTableColumnRangesOutput =
            LoadAppLogic.IsMatchTableColumnRanges(CreateEmptyLoadDBOutput, ReadCSVFileColumnNamesOutput);
        // 7.m. Control Flow: Decision
        if (!IsMatchTableColumnRangesOutput) throw new ApplicationException("IsMatchTableColumnRanges failed");
      }


      // 8. CompactDatabase
      LoadAppLogic.CompactDatabase(CreateEmptyLoadDBOutput);
    }
  }
}
