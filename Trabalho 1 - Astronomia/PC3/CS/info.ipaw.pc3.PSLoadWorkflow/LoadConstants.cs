using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace info.ipaw.pc3.PSLoadWorkflow {
  
  public static class LoadConstants {
    /// <summary>
    /// List of tables expected to be present in a CSV Batch
    /// </summary>
    public static List<string> EXPECTED_TABLES =
        new List<string>() {"P2Detection", "P2FrameMeta", "P2ImageMeta"};

    /// <summary>
    /// List of CSV file/table columns for the Detections file/table
    /// </summary>
    public static List<string> EXPECTED_DETECTION_COLS =
        new List<string>()
          {
              "objID", "detectID", "ippObjID", "ippDetectID", "filterID", "imageID", "obsTime", "xPos", "yPos", "xPosErr", "yPosErr", "instFlux", "instFluxErr", "psfWidMajor", "psfWidMinor", "psfTheta", "psfLikelihood", "psfCf", "infoFlag", "htmID", "zoneID", "assocDate", "modNum", "ra", "dec", "raErr", "decErr", "cx", "cy", "cz", "peakFlux", "calMag", "calMagErr", "calFlux", "calFluxErr", "calColor", "calColorErr", "sky", "skyErr", "sgSep", "dataRelease"
  };

    /// <summary>
    /// List of CSV file/table columns for the FrameMeta file/table
    /// </summary>
    public static List<string> EXPECTED_FRAME_META_COLS =
        new List<string>()
          {
              "frameID", "surveyID", "filterID", "cameraID", "telescopeID", "analysisVer", "p1Recip", "p2Recip", "p3Recip", "nP2Images", "astroScat", "photoScat", "nAstRef", "nPhoRef", "expStart", "expTime", "airmass", "raBore", "decBore"
          };

    /// <summary>
    /// List of CSV file/table columns for the ImageMeta file/table
    /// </summary>
    public static List<string> EXPECTED_IMAGE_META_COLS =
        new List<string>()
          {
              "imageID", "frameID", "ccdID", "photoCalID", "filterID", "bias", "biasScat", "sky", "skyScat", "nDetect", "magSat", "completMag", "astroScat", "photoScat", "nAstRef", "nPhoRef", "nx", "ny", "psfFwhm", "psfModelID", "psfSigMajor", "psfSigMinor", "psfTheta", "psfExtra1", "psfExtra2", "apResid", "dapResid", "detectorID", "qaFlags", "detrend1", "detrend2", "detrend3", "detrend4", "detrend5", "detrend6", "detrend7", "detrend8", "photoZero", "photoColor", "projection1", "projection2", "crval1", "crval2", "crpix1", "crpix2", "pc001001", "pc001002", "pc002001", "pc002002", "polyOrder", "pca1x3y0", "pca1x2y1", "pca1x1y2", "pca1x0y3", "pca1x2y0", "pca1x1y1", "pca1x0y2", "pca2x3y0", "pca2x2y1", "pca2x1y2", "pca2x0y3", "pca2x2y0", "pca2x1y1", "pca2x0y2"
  };


    /// <summary>
    /// 
    /// </summary>
    public class ColumnRange {
      public ColumnRange(string ColumnName_, string MinValue_, string MaxValue_) {
        ColumnName = ColumnName_;
        MinValue = MinValue_;
        MaxValue = MaxValue_;
      }
      public string ColumnName;
      public string MinValue;
      public string MaxValue;
    }

    /// <summary>
    /// 
    /// </summary>
    public static List<ColumnRange> EXPECTED_DETECTION_COL_RANGES =
        new List<ColumnRange>()
          {
              new ColumnRange("ra", "0", "360"),
              new ColumnRange("\"dec\"", "-90", "90"),
              new ColumnRange("raErr", "-2000", "9"),
              new ColumnRange("decErr", "0", "9"),
          };
  }
}
