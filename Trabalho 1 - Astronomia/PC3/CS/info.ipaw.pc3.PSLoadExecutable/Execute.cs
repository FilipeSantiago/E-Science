using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using info.ipaw.pc3.PSLoadWorkflow;


namespace info.ipaw.pc3.PSLoadExecutable {
  
  public class Execute {
    public const string USAGE =
        @"USAGE: 
PSLoadExecutable.exe <ActivityName> [-x '<XmlSerializedInputParam_1>'] [-x '<XmlSerializedInputParam_2>'] ...
PSLoadExecutable.exe <ActivityName> -o <FilePathToXmlSerializedOutputParam_1> [-f <FilePathToXmlSerializedParam_1>] [-f <FilePathToXmlSerializedInputParam_2>] ...";

    private const string ITER_CHAR = "?";

    public static void Main (string[] args) {
      if (args == null || args.Length == 0) throw new ApplicationException(USAGE);

      int Index = 0;
      // method to call
      string ActivityName = args[Index++];

      // write to console or file?
      TextWriter OutputWriter = null;
      string OutputFileName = null;
      if (Index < args.Length && "-o".Equals(args[Index], StringComparison.OrdinalIgnoreCase)) {
        Index++;
        OutputFileName = args[Index++];
        if(!OutputFileName.Contains(ITER_CHAR)) OutputWriter = new StreamWriter(OutputFileName);
      } else {
        OutputWriter = Console.Out;
      }

      string[] SerializedParams = new string[args.Length - Index];
      Array.Copy(args, Index, SerializedParams, 0, SerializedParams.Length);

      object Output = null;
      List<object> Params = ParseParams(SerializedParams);
      switch (ActivityName) {

        case "IsCSVReadyFileExists": {          
          var CSVRootPathInput = Params[0] as string;
          Output = LoadAppLogic.IsCSVReadyFileExists(CSVRootPathInput);
          break;
        }

        case "ReadCSVReadyFile": {
          var CSVRootPathInput = Params[0] as string;
          Output = LoadAppLogic.ReadCSVReadyFile(CSVRootPathInput);          
          break;
        }

        case "IsMatchCSVFileTables": {
            var CSVFileEntries = Params[0] as List<LoadAppLogic.CSVFileEntry>;
            Output = LoadAppLogic.IsMatchCSVFileTables(CSVFileEntries);
          break;
        }

        case "CreateEmptyLoadDB": {
            var JobIDInput = Params[0] as string;
            Output = LoadAppLogic.CreateEmptyLoadDB(JobIDInput);
            break;
          }

        case "SplitList": {
          var CSVFileEntries = Params[0] as List<LoadAppLogic.CSVFileEntry>;
          int FileCount = 0;
          foreach (LoadAppLogic.CSVFileEntry Entry in CSVFileEntries) {
            if (OutputFileName != null) {
              OutputWriter = new StreamWriter(OutputFileName.Replace(ITER_CHAR, "" + FileCount++));
              OutputWriter.Write(SerializeParam(Entry));
              OutputWriter.Close();
            } else {
              Console.WriteLine(SerializeParam(Entry));
              Console.WriteLine();
            }
          }
          return;
          //break;
        }

        case "IsExistsCSVFile": {
            var FileEntry = Params[0] as LoadAppLogic.CSVFileEntry;
            Output = LoadAppLogic.IsExistsCSVFile(FileEntry);
            break;
          }

        case "ReadCSVFileColumnNames": {
          var FileEntry = Params[0] as LoadAppLogic.CSVFileEntry;
          Output = LoadAppLogic.ReadCSVFileColumnNames(FileEntry);
          break;
        }

        case "IsMatchCSVFileColumnNames": {
            var FileEntry = Params[0] as LoadAppLogic.CSVFileEntry;
            Output = LoadAppLogic.IsMatchCSVFileColumnNames(FileEntry);
          break;
        }

        case "LoadCSVFileIntoTable": {
          var DBEntry = Params[0] as LoadAppLogic.DatabaseEntry;
          var FileEntry = Params[1] as LoadAppLogic.CSVFileEntry;
          Output = LoadAppLogic.LoadCSVFileIntoTable(DBEntry, FileEntry);
          break;
        }

        case "UpdateComputedColumns": {
            var DBEntry = Params[0] as LoadAppLogic.DatabaseEntry;
            var FileEntry = Params[1] as LoadAppLogic.CSVFileEntry;
            Output = LoadAppLogic.UpdateComputedColumns(DBEntry, FileEntry);
            break;
        }

        case "IsMatchTableRowCount": {
          var DBEntry = Params[0] as LoadAppLogic.DatabaseEntry;
          var FileEntry = Params[1] as LoadAppLogic.CSVFileEntry;
          Output = LoadAppLogic.IsMatchTableRowCount(DBEntry, FileEntry);
          break;
        }

        case "IsMatchTableColumnRanges": {
          var DBEntry = Params[0] as LoadAppLogic.DatabaseEntry;
          var FileEntry = Params[1] as LoadAppLogic.CSVFileEntry;
          Output = LoadAppLogic.IsMatchTableColumnRanges(DBEntry, FileEntry);
          break;
        }

        case "CompactDatabase": {
          var DBEntry = Params[0] as LoadAppLogic.DatabaseEntry;
          LoadAppLogic.CompactDatabase(DBEntry);
          break;
        }

        default: {
          Console.WriteLine("Activity not found! " + ActivityName);
          break;
        }
      }

      if (Output != null) {
        OutputWriter.Write(SerializeParam(Output));
        OutputWriter.Close();
      }
    }

    public static List<object> ParseParams(string[] Params) {
      List<object> OutputParams = new List<object>();
      if (Params == null || Params.Length == 0) return OutputParams;
      if (Params.Length % 2 != 0) throw new ApplicationException("Odd number of args.");

      int Index = 0;      
      while(Index < Params.Length) {
        string SerializedParam;
        if("-f".Equals(Params[Index], StringComparison.OrdinalIgnoreCase)) {
          Index++;
          SerializedParam = ReadFile(Params[Index]);
          Index++;
        } else
          if ("-x".Equals(Params[Index], StringComparison.OrdinalIgnoreCase)) {
            Index++;
            SerializedParam = Params[Index];
            Index++;
          }
          else {
            throw new ApplicationException("Unknown flag." + Params[Index]);
          }

        OutputParams.Add(DeserializeParam(SerializedParam));
      }

      return OutputParams;
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="SerializedParam"></param>
    /// <returns></returns>
    private static object DeserializeParam (string SerializedParam) {
      StringReader SReader = new StringReader(SerializedParam);
      XmlReader XReader = XmlReader.Create(SReader);
      XReader.Read();
      // read XML encoding declaration if present
      if (XReader.NodeType == XmlNodeType.XmlDeclaration)
        XReader.Read();
      //XReader.ReadStartElement();
      string ElementName = XReader.Name;
      string ParamTypeStr = XReader.NamespaceURI;

      XmlRootAttribute xRoot = new XmlRootAttribute();
      xRoot.ElementName = ElementName;
      xRoot.Namespace = ParamTypeStr;
      xRoot.IsNullable = false;
      Type ParamType = Type.GetType(ParamTypeStr);

      {
        XmlSerializer Deserializer = new XmlSerializer(ParamType, xRoot);
        SReader = new StringReader(SerializedParam);
        return Deserializer.Deserialize(SReader);
      }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="FileName"></param>
    /// <returns></returns>
    public static string ReadFile(string FileName) {
      using (StreamReader SReader = new StreamReader(new FileStream(FileName, FileMode.Open, FileAccess.Read))) {
        FileInfo FInfo = new FileInfo(FileName);
        char[] FBuffer = new char[FInfo.Length];
        SReader.ReadBlock(FBuffer, 0, FBuffer.Length);
        return new string(FBuffer);
      }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ParamValue"></param>
    /// <returns></returns>
    public static string SerializeParam(object ParamValue) {
      
      XmlRootAttribute xRoot = new XmlRootAttribute();
      // Use default ElementName but override with our xmlns for getting the type (equiv of xsi:type)
      xRoot.Namespace = ParamValue.GetType().AssemblyQualifiedName;
      xRoot.IsNullable = false;

      XmlSerializer serializer = new XmlSerializer(ParamValue.GetType(), xRoot);
      TextWriter TWriter = new StringWriterUTF8();
      XmlWriter XWriter = new XmlTextWriter(TWriter); // force UTF-8 Encoding
      // Serialize using the XmlTextWriter.
      serializer.Serialize(XWriter, ParamValue);
      XWriter.Close();

      return TWriter.ToString();
    }

    
    public class StringWriterUTF8 : StringWriter {
      public override Encoding Encoding {
        get { return Encoding.UTF8; }
      }
    }
  }
}
