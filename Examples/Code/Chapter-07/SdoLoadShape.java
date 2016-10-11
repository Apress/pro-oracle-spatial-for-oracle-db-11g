/*
 * @(#)SdoLoadShape.java 2.0 12-Jun-2007
 *
 * This program loads the contents of an ESRI shape file
 * into a database table.
 *
 * It uses the Java API for Oracle Spatial supplied with
 * version 11.1 or the Oracle Server, specifically the
 * utility functions in package oracle.spatial.util
 *
 * The program lets you specify connection parameters to a database, as
 * well as the name of a table and the name of the geometry column to
 * load into. It also lets you specify the name of an identification
 * column (a number) that it automatically populates as a sequential
 * number.
 *
 * You need to specify the name of the input shapefile as well as
 * the SRID to use for the geometries.
 *
 * You can specify the frequency of commits, as:
 *   0 = only commit once at the end, after all rows have been
 *       inserted
 *   1 = commit after every insert (using the autocommit option)
 *   N = commit every time N rows are inserted
 *
 * You can also choose to create the output table
 * prior to loading the geometries.
 *
 * Finally, you can also choose the unpickler to use:
 *  0 = use the standard JDBC unpickler
 *  1 = use the faster spatial object unpickler
 *
 */

import java.io.*;
import java.sql.*;
import java.util.*;
import oracle.jdbc.driver.*;
import oracle.spatial.geometry.*;
import oracle.spatial.util.*;

public final class SdoLoadShape
{
  static boolean verbose = false;

  public static void main(String args[]) throws Exception
  {

    System.out.println ("SdoLoadShape - Oracle Spatial (SDO) Shapefile loader");

    // Check and process command line arguments

    if (args.length < 8) {
      System.out.println ("Parameters:");
      System.out.println ("<Connection>:   JDBC connection string");
      System.out.println ("                e.g: jdbc:oracle:thin:@server:port:sid");
      System.out.println ("<User>:         User name");
      System.out.println ("<Password>:     User password");
      System.out.println ("<Table name>:   Table to load into");
      System.out.println ("<Geo column>:   Name of geometry colum,");
      System.out.println ("<ID column>:    Name of id colum,");
      System.out.println ("<Shape File>:   Name of shape file");
      System.out.println ("<SRID>:         SRID to be used for geometries");
      System.out.println ("<Commit>:       0=commit once, 1=autocommit, other= commit interval");
      System.out.println ("<Create>:       0=no, 1=yes");
      System.out.println ("<Fast Pickle>:  0=no, 1=yes");
      System.out.println ("<Verbose>:      0=no, 1=yes");
      return;
    }

    String  connectionString  = args[0];
    String  userName          = args[1];
    String  userPassword      = args[2];
    String  tableName         = args[3];
    String  geoColumn         = args[4];
    String  idColumn          = args[5];
    String  shapeFileName     = args[6];
    int     srid              = Integer.parseInt(args[7]);
    int     commitFrequency   = (args.length > 8 ? Integer.parseInt(args[8]) : 0);
    boolean createTable       = (args.length > 9 ? (Integer.parseInt(args[9])==1) : false);
    boolean fastPickle        = (args.length > 10 ? (Integer.parseInt(args[10])==1) : false);
    verbose                   = (args.length > 11 ? (Integer.parseInt(args[11])==1) : false);

    // Register the Oracle JDBC driver
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

    // Get a connection to the database
    System.out.println ("Connecting to database '"+connectionString+"'");
    Connection dbConnection = DriverManager.getConnection(connectionString, userName, userPassword);
    System.out.println ("Using JDBC Driver Version: " + dbConnection.getMetaData().getDriverVersion());
    System.out.println ("Commit frequency: " + commitFrequency);
    System.out.println ("Fast Pickle: " + fastPickle);

    // Import the geometries
    loadGeometries(dbConnection, tableName, geoColumn, idColumn, shapeFileName, srid, commitFrequency, createTable, fastPickle);

    // Close database connection
    dbConnection.close();
  }

  static void loadGeometries(Connection dbConnection, String tableName,
    String geoColumn, String idColumn, String shapeFileName, int srid, int commitFrequency, boolean createTable, boolean fastPickle)
    throws Exception
  {
    long totalMs = 0;
    long otherMs = 0;
    long getObjectMs = 0;
    long storeGeomMs = 0;
    long insertMs = 0;
    long start, end;
    long totalPoints = 0;
    long totalSize = 0;

    // Open SHP and DBF files
    System.out.println ("Opening shapefile "+shapeFileName);
    ShapefileReaderJGeom shpr = new ShapefileReaderJGeom(shapeFileName);
    DBFReaderJGeom dbfr = new DBFReaderJGeom(shapeFileName);

    // Get shapefile details
    int shpFileType = shpr.getShpFileType();
    double minX = shpr.getMinX();
    double maxX = shpr.getMaxX();
    double minY = shpr.getMinY();
    double maxY = shpr.getMaxY();
    double minZ = shpr.getMinZ();
    double maxZ = shpr.getMaxZ();
    double minM = shpr.getMinMeasure();
    double maxM = shpr.getMaxMeasure();
    int shpDims = shpr.getShpDims(shpFileType, maxM);
    int numRows = shpr.numRecords();

    // Show shapefile summary
    System.out.println ("Shape File Details");
    System.out.println ("  Shape file type: "+ shpFileType);
    System.out.println ("  Dimensions: "+ shpDims);
    System.out.println ("  Bounds: ");
    System.out.println ("    X ["+minX+","+maxX+"]");
    System.out.println ("    Y ["+minY+","+maxY+"]");
    System.out.println ("    Z ["+minZ+","+maxZ+"]");
    System.out.println ("    M ["+minM+","+maxM+"]");
    System.out.println ("  Number of records: "+ numRows);

    // Show DBF summary
    System.out.println ("DBF File Details");
    System.out.println ("  Number of fields: "+ dbfr.numFields());
    System.out.println ("  Number of records: "+ dbfr.numRecords());
    System.out.println ("  Record Size: "+ dbfr.recordSize());
    if (verbose) {
      System.out.println ("  Fields");
      for (int i=0; i<dbfr.numFields(); i++)
        System.out.println ("    ["+(i+1)+"] "
          + " N:" + dbfr.getFieldName(i)
          + " T:" + (char) dbfr.getFieldType(i)
          + " L:" + dbfr.getFieldLength(i)
        );
    }

    // Extract DBF field structure and convert to oracle types
    int numFields = dbfr.numFields();
    String[] fieldName   = new String[numFields];
    byte[]   fieldType   = new byte[numFields];
    int[]    fieldLength = new int[numFields];
    String[] oracleType  = new String[numFields];
    for (int i=0; i<numFields; i++) {
      fieldName[i] = dbfr.getFieldName(i);
      fieldType[i] = dbfr.getFieldType(i);
      fieldLength[i] = dbfr.getFieldLength(i);
      switch (fieldType[i]) {
        // Character types
        case 'C':   // Character
          oracleType[i] = "VARCHAR2(" + fieldLength[i] + ")";
          break;
        case 'L':  // Logical
          oracleType[i] = "CHAR(1)";
          break;
        // Date types
        case 'D':  // Date
          oracleType[i] = "DATE";
          break;
        // Numeric types
        case 'I':  // Integer
        case 'F':  // Float
        case 'N':  // Numeric
          oracleType[i] = "NUMBER";
          break;
        default:
          throw new RuntimeException("Unsupported DBF field type " + fieldType[i]);
      }
    }

    // Set autocommit if commit frequency is 1
    if (commitFrequency == 1)
      dbConnection.setAutoCommit(true);
    else
      dbConnection.setAutoCommit(false);

    // Set decimal separator to '.' (to avoid language/territory dependencies)
    PreparedStatement nlsStmt = dbConnection.prepareStatement("ALTER SESSION SET NLS_NUMERIC_CHARACTERS='.,'");
    nlsStmt.execute();

    // Create table before loading if necessary
    if (createTable) {

      // Drop existing table first
      System.out.println ("Dropping old table...");
      PreparedStatement stmt;
      try {
        stmt = dbConnection.prepareStatement("DROP TABLE "+tableName);
        stmt.execute();
      }
      catch (SQLException e) {
        // If table does not exist, ignore the exception
        if (e.getErrorCode() != 942)
          throw (e);
      }

      // Construct the "CREATE TABLE" statement
      String createTableSql = "CREATE TABLE " + tableName + "(" + idColumn + " NUMBER PRIMARY KEY,";
      for (int i=0; i<numFields; i++)
        createTableSql = createTableSql + fieldName[i] + " " + oracleType[i] + ",";
      createTableSql = createTableSql + geoColumn + " SDO_GEOMETRY)";

      // Create the table
      System.out.println ("Creating new table...");
      if (verbose)
        System.out.println (createTableSql);
      stmt = dbConnection.prepareStatement(createTableSql);
      stmt.execute();
    }

    // Construct the SQL insert statement
    String insertSql = "INSERT INTO " + tableName + " (" + idColumn + ",";
    for (int i=0; i<numFields; i++)
      insertSql = insertSql + fieldName[i] + ",";
    insertSql = insertSql + geoColumn + ") VALUES (?,";
    for (int i=0; i<numFields; i++)
      if (fieldType[i] == 'D')
        insertSql = insertSql + "TO_DATE(?,'YYYYMMDD'),";
      else
        insertSql = insertSql + "?,";
    insertSql = insertSql + "?)";

    System.out.println ("Loading data ...");
    if (verbose)
      System.out.println ("Executing query: '"+insertSql+"'");

    // Prepare the insert statement
    PreparedStatement stmt = dbConnection.prepareStatement(insertSql);

    totalMs = System.currentTimeMillis();

    // Process the shape file
    int rowNumber;
    for (rowNumber = 0; rowNumber < numRows; rowNumber++)
    {

      // Extract geometry from shape file
      start = System.currentTimeMillis();
      byte[] s = shpr.getGeometryBytes (rowNumber);
      JGeometry geom = ShapefileReaderJGeom.getGeometry (s, srid);
      end = System.currentTimeMillis();
      getObjectMs += (end - start);

      // Convert JGeometry object into database object
      start = System.currentTimeMillis();
      if (fastPickle) {
        // Convert JGeometry into an Oracle STRUCT
        Struct dbObject = JGeometry.store (dbConnection, geom);
        // Write Oracle STRUCT into database object
        stmt.setObject (numFields+2, dbObject);
      }
      else {
        // Convert JGeometry into an Oracle STRUCT
        Struct dbObject = JGeometry.store (geom, dbConnection);
        // Write Oracle STRUCT into database object
        stmt.setObject (numFields+2, dbObject);
      }
      end = System.currentTimeMillis();
      storeGeomMs += (end - start);

      // Extract attributes values from DBF record
      stmt.setInt (1, rowNumber+1);
      byte[] a = dbfr.getRecord (rowNumber);
      for (int i = 0; i< dbfr.numFields(); i++) {
        stmt.setString (i+2,dbfr.getFieldData(i, a));
      }

      // Insert row into the database table
      start = System.currentTimeMillis();
      stmt.execute();
      end = System.currentTimeMillis();
      insertMs += (end - start);

      // Keep counts
      long gNumPoints = geom.getNumPoints();
      long gSize = geom.getSize();
      totalSize += gSize;
      totalPoints += gNumPoints;

      // Commit if needed
      if (commitFrequency > 1)
        if (rowNumber % commitFrequency == 0) {
          System.out.println (rowNumber + " rows inserted");
          dbConnection.commit();
        }

    }
    stmt.close();

    // Final commit if necessary
    if (commitFrequency != 0) {
      System.out.println (rowNumber + " rows inserted");
      dbConnection.commit();
    }

    // Close input file
    shpr.closeShapefile();
    dbfr.closeDBF();

    // Show timings and counts
    totalMs = System.currentTimeMillis() - totalMs;
    otherMs = totalMs - (getObjectMs + storeGeomMs + insertMs);

    System.out.println("");
    System.out.println("Done - "+rowNumber+" rows loaded");
    System.out.println(" " + totalPoints + " vertices");
    System.out.println(" " + totalSize + " bytes");

    System.out.println("");
    System.out.println("Reading geometries:         " + getObjectMs + " ms");
    System.out.println("Converting to SDO_GEOMETRY: " + storeGeomMs + " ms");
    System.out.println("Inserting:                  " + insertMs + " ms");
    System.out.println("Other:                      " + otherMs + " ms");
    System.out.println("Total elapsed:              " + totalMs + " ms");
  }

}
