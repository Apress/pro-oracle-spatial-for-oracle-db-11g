/*
 * @(#)SdoImport.java 2.0 12-Jun-2007
 *
 * This program reads geometries in various formats from an
 * input file, inserts them in a database table.
 *
 * It uses the Java API for Oracle Spatial supplied with
 * version 11.1 or the Oracle Server (class JGeometry) together
 * with utility functions in package oracle.spatial.util
 *
 * The program lets you specify connection parameters to a database, as
 * well as the name of a table and the name of the geometry column to
 * load into. It also lets you specify the name of an identification
 * column (a number) that it automatically populates as a sequential
 * number.
 *
 * You need to specify the format in which the geometries are
 * encoded in the input file. Possible formats are:
 *  JAVA = serialized java objects
 *  WKT  = OGC WKT encoding
 *  WKB  = OGC WKB encoding
 *  GML  = GML2 encoding
 *  GML3 = GML3 encoding
 *
 * You can specify the frequency of commits, as:
 *   0 = only commit once at the end, after all rows have been
 *       inserted
 *   1 = commit after every insert (using the autocommit option)
 *   N = commit every time N rows are inserted
 *
 * You can also choose to truncate the output table
 * prior to loading the geometries.
 *
 * Finally, you can also choose the unpickler to use:
 *  0 = use the standard JDBC pickler
 *  1 = use the faster spatial object pickler
 *
 */

import java.io.*;
import java.sql.*;
import java.util.*;
import java.awt.geom.*;
import oracle.xml.parser.v2.*;
import org.w3c.dom.*;
import oracle.jdbc.driver.*;
import oracle.spatial.geometry.*;
import oracle.spatial.util.*;

public final class SdoImport
{

  public static void main(String args[]) throws Exception
  {

    System.out.println ("SdoImport - Oracle Spatial (SDO) Import");

    // Check and process command line arguments

    if (args.length < 7) {
      System.out.println ("Parameters:");
      System.out.println ("<Connection>:   JDBC connection string");
      System.out.println ("                e.g: jdbc:oracle:thin:@server:port:sid");
      System.out.println ("<User>:         User name");
      System.out.println ("<Password>:     User password");
      System.out.println ("<Table name>:   Table to import");
      System.out.println ("<Geo column>:   Name of geometry colum,");
      System.out.println ("<ID column>:    Name of gid colum,");
      System.out.println ("<Input File>:   Name of input file");
      System.out.println ("<Input Format>: Format to be used for the output");
      System.out.println ("                  JAVA = serialized Java objects");
      System.out.println ("                  WKT = OGC Well-Known Text");
      System.out.println ("                  WKB = OGC Well-Known Binary");
      System.out.println ("                  GML = OGC GML");
      System.out.println ("                  GML3 = OGC GML3");
      System.out.println ("<Commit>:       0=commit once, 1=autocommit, other= commit interval");
      System.out.println ("<Truncate>:     0=no, 1=yes");
      System.out.println ("<Fast Pickle>:  0=no, 1=yes");
      return;
    }

    String  connectionString  = args[0];
    String  userName          = args[1];
    String  userPassword      = args[2];
    String  tableName         = args[3];
    String  geoColumn         = args[4];
    String  idColumn          = args[5];
    String  inputFileName     = args[6];
    String  inputFormat       = args[7];
    int     commitFrequency   = (args.length > 8 ? Integer.parseInt(args[8]) : 0);
    boolean truncateTable     = (args.length > 9 ? (Integer.parseInt(args[9])==1) : false);
    boolean fastPickle        = (args.length > 10 ? (Integer.parseInt(args[10])==1) : false);

    // Register the Oracle JDBC driver
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

    // Get a connection to the database
    System.out.println ("Connecting to database '"+connectionString+"'");
    Connection dbConnection = DriverManager.getConnection(connectionString, userName, userPassword);
    System.out.println ("Using JDBC Driver Version: " + dbConnection.getMetaData().getDriverVersion());
    System.out.println ("Commit frequency: " + commitFrequency);
    System.out.println ("Fast Pickle: " + fastPickle);

    // Import the geometries
    importGeometries(dbConnection, tableName, geoColumn, idColumn, inputFileName, inputFormat, commitFrequency, truncateTable, fastPickle);

    // Close database connection
    dbConnection.close();
  }

  static void importGeometries(Connection dbConnection, String tableName,
    String geoColumn, String idColumn, String inputFileName, String inputFormat, int commitFrequency, boolean truncateTable, boolean fastPickle)
    throws Exception
  {
    long totalMs = 0,
         otherMs = 0;
    long getObjectMs = 0,
         storeGeomMs = 0,
         insertMs = 0;
    long start, end;
    long totalPoints = 0;
    long totalSize = 0;

    JGeometry geom = null;;

    // Open input file
    System.out.println ("Opening file '" + inputFileName + "'");
    FileInputStream inputFile = new FileInputStream(inputFileName);

    // Use the proper input stream
    ObjectInputStream objectInputFile = null;;
    DataInputStream dataInputFile = null;
    BufferedReader textInputFile = null;;

    if (inputFormat.equals("JAVA"))
      objectInputFile = new ObjectInputStream(inputFile);
    else if (inputFormat.equals("WKB"))
      dataInputFile = new DataInputStream(inputFile);
    else if (inputFormat.equals("WKT") | inputFormat.equals("GML") | inputFormat.equals("GML3") )
      textInputFile = new BufferedReader (new InputStreamReader(inputFile));

    // Create WKT, WKB and GML processors
    WKT   wkt  = new WKT();
    WKB   wkb  = new WKB();
    GML   gml  = new GML();
    GML3g gml3 = new GML3g();

    // Check commit frequency
    if (commitFrequency == 1)
      dbConnection.setAutoCommit(true);
    else
      dbConnection.setAutoCommit(false);

    // Truncate table before loading if necessary
    if (truncateTable) {
      System.out.println ("Truncating table: "+tableName);
      PreparedStatement stmt = dbConnection.prepareStatement("TRUNCATE TABLE "+tableName);
      stmt.execute();
    }

    // Construct the SQL insert statement
    String sqlInsert = "INSERT INTO " + tableName + " (" + idColumn + "," + geoColumn + ") " +
      "VALUES (?, ?)";
    System.out.println ("Executing query: '"+sqlInsert+"'");

    // Prepare the statement
    PreparedStatement stmt = dbConnection.prepareStatement(sqlInsert);

    totalMs = System.currentTimeMillis();

    // Process results
    int rowNumber = 0;
    boolean completed = false;

    while (!completed)
    {

      try {

        // Extract JGeometry object from object stream
        start = System.currentTimeMillis();
        if (inputFormat.equals("JAVA")) {
          // Extract serialized object from input stream
          geom = (JGeometry) objectInputFile.readObject();
        }
        else if (inputFormat.equals("WKT")) {
          // Read next line from input stream
          String s = textInputFile.readLine();
          // If no string, indicate we are done
          if (s == null)
            throw new EOFException();
          // Convert to geometry
          geom = wkt.toJGeometry(s.getBytes());
        }
        else if (inputFormat.equals("WKB")) {
          // Read the size of the byte array
          int n = dataInputFile.readInt();
          // Read the SRID of the geometry
          int srid = dataInputFile.readInt();
          // Read the byte array that contains the WKB
          byte[] b = new byte[n];
          int l = dataInputFile.read (b, 0, n);
          // Convert to JGeometry
          geom = wkb.toJGeometry(b);
          // Add the SRID
          geom.setSRID(srid);
        }
        else if (inputFormat.equals("GML")) {
          // Read next line from input stream
          String s = textInputFile.readLine();
          // If no string, indicate we are done
          if (s == null)
            throw new EOFException();
          // Parse in DOM
          DOMParser parser = new DOMParser();
          parser.parse(new StringReader(s));
          Document document = parser.getDocument();
          Node node = document.getDocumentElement();
          // Convert to geometry
          geom = gml.fromNodeToGeometry(node);
        }
        else if (inputFormat.equals("GML3")) {
          // Read next line from input stream
          String s = textInputFile.readLine();
          // If no string, indicate we are done
          if (s == null)
            throw new EOFException();
          // Parse in DOM
          DOMParser parser = new DOMParser();
          parser.parse(new StringReader(s));
          Document document = parser.getDocument();
          Node node = document.getDocumentElement();
          // Convert to geometry
          geom = gml3.fromNodeToGeometry(node);
        }
        end = System.currentTimeMillis();
        getObjectMs += (end - start);

        // Convert JGeometry object into database object
        start = System.currentTimeMillis();
        if (fastPickle) {
          // Convert JGeometry into an Oracle STRUCT
          Struct dbObject = JGeometry.store (dbConnection, geom);
          // Write Oracle STRUCT into database object
          stmt.setObject (2, dbObject);
          // Convert JGeometry into raw bytes
          // byte[] image  = JGeometry.store(geom);
          // Write raw bytes into database object
          // stmt.setBytes(2, image);
        }
        else {
          // Convert JGeometry into an Oracle STRUCT
          Struct dbObject = JGeometry.store (geom, dbConnection);
          // Write Oracle STRUCT into database object
          stmt.setObject (2, dbObject);
        }
        end = System.currentTimeMillis();
        storeGeomMs += (end - start);

        // Insert row into the database table
        ++rowNumber;
        start = System.currentTimeMillis();
        stmt.setInt (1, rowNumber);
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
      catch (EOFException x) {
        completed = true;
      }
    }
    stmt.close();

    // Final commit if necessary
    if (commitFrequency != 0) {
      System.out.println (rowNumber + " rows inserted");
      dbConnection.commit();
    }

    // Close input file
    if (inputFormat.equals("JAVA"))
      objectInputFile.close();
    else if (inputFormat.equals("WKB"))
      dataInputFile.close();
    else if (inputFormat.equals("WKT") | inputFormat.equals("GML") | inputFormat.equals("GML3"))
      textInputFile.close();
    else
      inputFile.close();

    totalMs = System.currentTimeMillis() - totalMs;
    otherMs = totalMs - (getObjectMs + storeGeomMs + insertMs);

    System.out.println("");
    System.out.println("Done - "+rowNumber+" geometries imported");
    System.out.println(" " + totalPoints + " vertices");
    System.out.println(" " + totalSize + " bytes");

    System.out.println("");
    System.out.println("Reading:                " + getObjectMs + " ms");
    System.out.println("Converting to STRUCT:   " + storeGeomMs + " ms");
    System.out.println("Inserting:              " + insertMs + " ms");
    System.out.println("Other:                  " + otherMs + " ms");
    System.out.println("Total elapsed:          " + totalMs + " ms");
  }

}
