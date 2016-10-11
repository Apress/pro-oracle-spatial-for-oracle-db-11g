/*
 * @(#)SdoExport.java 2.0 12-Jun-2007
 *
 * This program selects geometries from a database tables and
 * writes them out to a file in a chosen formet.
 *
 * It uses the Java API for Oracle Spatial supplied with
 * version 11.1 or the Oracle Server (class JGeometry) together
 * with utility functions in package oracle.spatial.util
 *
 * The program lets you specify connection parameters to a database, as
 * well as the name of a table and the name of a geometry column to
 * process. You can optionally specify a predicate (a WHERE clause) to select
 * the rows to export.
 *
 * You can decide on the format to use for the exported geometries.
 * Choose one of the following:
 *  JAVA = write the geometries as serialized java objects
 *  WKT  = write them in text format, using the OGC WKT encoding
 *  WKB  = write them in binary format, usiong the OGC WKB encoding
 *  GML  = write them in text format, using the GML2 encoding
 *  GML3 = write them in text format, using the GML3 encoding
 *
 * Finally, you can also choose the unpickler to use:
 *  0 = use the standard JDBC unpickler
 *  1 = use the faster spatial object unpickler
 *
 */

import java.io.*;
import java.sql.*;
import oracle.sql.*;
import oracle.spatial.geometry.*;
import oracle.spatial.util.*;

public final class SdoExport
{

  public static void main(String args[]) throws Exception
  {

    System.out.println ("SdoExport - Oracle Spatial (SDO) export");

    // Check and process command line arguments

    if (args.length < 8) {
      System.out.println ("Parameters:");
      System.out.println ("<Connection>:    JDBC connection string");
      System.out.println ("                 e.g: jdbc:oracle:thin:@server:port:sid");
      System.out.println ("<User>:          User name");
      System.out.println ("<Password>:      User password");
      System.out.println ("<Table name>:    Table to export");
      System.out.println ("<Geo column>:    Name of geometry colum,");
      System.out.println ("<Predicate>:     WHERE clause");
      System.out.println ("<Output File>:   Name of output file");
      System.out.println ("<Output Format>: Format to be used for the output");
      System.out.println ("                 JAVA = serialized Java objects");
      System.out.println ("                 WKT = OGC Well-Known Text");
      System.out.println ("                 WKB = OGC Well-Known Binary");
      System.out.println ("                 GML = OGC GML");
      System.out.println ("                 GML3 = OGC GML3");
      System.out.println ("<Fast Unpickle>: 0=no, 1=yes");
      return;
    }

    String  connectionString  = args[0];
    String  userName          = args[1];
    String  userPassword      = args[2];
    String  tableName         = args[3];
    String  geoColumn         = args[4];
    String  predicate         = args[5];
    String  outputFileName    = args[6];
    String  outputFormat      = args[7];
    boolean fastUnpickle      = (args.length > 8 ? (Integer.parseInt(args[8])==1) : false);

    // Register the Oracle JDBC driver
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

    // Get a connection to the database
    System.out.println ("Connecting to database '"+connectionString+"'");
    Connection dbConnection = DriverManager.getConnection(connectionString, userName, userPassword);
    System.out.println ("Using JDBC Driver Version: " + dbConnection.getMetaData().getDriverVersion());
    System.out.println ("Fast unpickle = "+fastUnpickle);

    // Export the geometries
    exportGeometries(dbConnection, tableName, geoColumn, predicate, outputFileName, outputFormat, fastUnpickle);

    // Close database connection
    dbConnection.close();

  }

  static void exportGeometries(Connection dbConnection, String tableName,
    String geoColumn, String predicate, String outputFileName, String outputFormat, boolean fastUnpickle)
    throws Exception
  {
    long totalMs = 0,
         otherMs = 0;
    long loadGeomMs = 0,
         processMs = 0;
    long start, end;
    long totalPoints = 0;
    long totalSize = 0;

    JGeometry geom;

    // Create output file
    System.out.println ("Creating file '" + outputFileName + "'");
    FileOutputStream outputFile = new FileOutputStream(outputFileName);

    // Use the proper output stream
    ObjectOutputStream objectOutputFile = null;      // Used for objects
    DataOutputStream dataOutputFile = null;          // Used for binary output
    Writer textOutputFile = null;                    // Used for text output

    if (outputFormat.equals("JAVA"))
      objectOutputFile = new ObjectOutputStream(outputFile);
    else if (outputFormat.equals("WKB"))
      dataOutputFile = new DataOutputStream(outputFile);
    else if (outputFormat.equals("WKT") | outputFormat.equals("GML") | outputFormat.equals("GML3") )
      textOutputFile = new BufferedWriter (new OutputStreamWriter(outputFile));

    // Create WKT, WKB and GML processors
    WKT  wkt  = new WKT();
    WKB  wkb  = new WKB(ByteOrder.BIG_ENDIAN);
    GML2 gml  = new GML2();
    GML3 gml3 = new GML3();

    // Construct SQL query
    String sqlQuery = "SELECT " + geoColumn + " FROM " + tableName + " "
      + predicate;
    System.out.println ("Executing query: '"+sqlQuery+"'");

    totalMs = System.currentTimeMillis();

    // Execute query
    Statement stmt = dbConnection.createStatement();
    ResultSet rs = stmt.executeQuery(sqlQuery);

    // Process results
    int rowNumber = 0;
    while (rs.next())
    {
      ++rowNumber;

      // Import from structure into Geometry object
      start = System.currentTimeMillis();
      if (fastUnpickle) {
        // Extract JDBC object as raw bytes
        byte[] image = rs.getBytes(1);
        // Convert into JGeometry
        geom = JGeometry.load(image);
      }
      else {
        // Extract JDBC object as an Oracle STRUCT
        STRUCT dbObject = (STRUCT) rs.getObject(1);
        // Convert structure into a JGeometry
        geom = JGeometry.load(dbObject);
      }
      end = System.currentTimeMillis();
      loadGeomMs += (end - start);

      // Export Geometry object
      start = System.currentTimeMillis();
      if (outputFormat.equals("JAVA")) {
        // Write serialized object
        objectOutputFile.writeObject(geom);
      }
      else if (outputFormat.equals("WKT")) {
        // Write the WKT text notation as a an array of bytes
        // This is safe since the WKT notation only uses 7-bit ascii encoding
        textOutputFile.write(new String(wkt.fromJGeometry(geom)));
        // Add a newline separator
        textOutputFile.write('\n');
      }
      else if (outputFormat.equals("WKB")) {
        // Convert JGeometry to WKB
        byte[] b = wkb.fromJGeometry(geom);
        // First write the number of bytes in the array
        dataOutputFile.writeInt(b.length);
        // Then write the SRID of the geometry
        dataOutputFile.writeInt(geom.getSRID());
        // Then write the binary array
        dataOutputFile.write(b);
      }
      else if (outputFormat.equals("GML")) {
        // Write the GML notation as a string
        textOutputFile.write(gml.to_GMLGeometry(geom));
        // Add a newline separator
        textOutputFile.write('\n');
      }
      else if (outputFormat.equals("GML3")) {
        // Write the GML notation as a string
        textOutputFile.write(gml3.to_GML3Geometry(geom));
        // Add a newline separator
        textOutputFile.write('\n');
      }
      end = System.currentTimeMillis();
      processMs += (end - start);

      totalSize += geom.getSize();
      totalPoints += geom.getNumPoints();

    }
    stmt.close();

    // Close output file
    if (outputFormat.equals("JAVA"))
      objectOutputFile.close();
    else if (outputFormat.equals("WKB"))
      dataOutputFile.close();
    else if (outputFormat.equals("WKT") | outputFormat.equals("GML") | outputFormat.equals("GML3"))
      textOutputFile.close();
    else
      outputFile.close();

    totalMs = System.currentTimeMillis() - totalMs;
    otherMs = totalMs - (loadGeomMs + processMs);

    System.out.println("");
    System.out.println("Done - "+rowNumber+" geometries exported");
    System.out.println(" " + totalPoints + " vertices");
    System.out.println(" " + totalSize + " bytes");

    System.out.println("");
    System.out.println("Converting to JGeometry: " + loadGeomMs + " ms");
    System.out.println("Writing:                 " + processMs + " ms");
    System.out.println("Other:                   " + otherMs + " ms");
    System.out.println("Total elapsed:           " + totalMs + " ms");
  }


}
