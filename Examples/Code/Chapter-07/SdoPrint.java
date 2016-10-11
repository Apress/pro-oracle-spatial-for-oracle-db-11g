/*
 * @(#)SdoPrint.java 2.0 12-Jun-2007
 *
 * This program uses the Java API for Oracle Spatial supplied with
 * version 11.1 of the Oracle Server (class JGeometry)
 *
 * It illustrates the use of Geometry to extract and process geometry
 * objects stored in tables inside the Oracle database using the
 * SDO_GEOMETRY object type.
 *
 * The program lets you specify connection parameters to a database, as
 * well as the name of a table and the name of a geometry column to
 * process. You can optionally specify a predicate (a WHERE clause) to select
 * the rows to fetch.
 *
 * Then you can choose the way the geometries will be formatted:
 *
 *  0 = no output.
 *  1 = format using the toStringFull() method of JGeometry
 *  2 = format as an SDO_GEOMETRY constructor (similar to SQLPLUS output)
 *  4 = display the results from each getXxx() and isXxx() methods of the
 *      Geometry objects
 *
 * You can combine the settings. For example, 3 shows both formats.
 *
 * Finally, you can choose the unpickler to use:
 *  0 = use the standard JDBC unpickler
 *  1 = use the faster spatial object unpickler
 *
 * The program also times the individual steps needed to convert
 * a geometry into a JGeometry and displays the total time
 */

import java.sql.*;
import java.awt.geom.*;
import java.awt.Shape;
import oracle.sql.*;
import oracle.spatial.geometry.*;

public final class SdoPrint
{

  public static void main(String args[]) throws Exception
  {
    System.out.println ("SdoPrint - Oracle Spatial (SDO) read");

    // Check and process command line arguments
    if (args.length < 7) {
      System.out.println ("Parameters:");
      System.out.println ("<Connection>:    JDBC connection string");
      System.out.println ("                 e.g: jdbc:oracle:thin:@server:port:sid");
      System.out.println ("<User>:          User name");
      System.out.println ("<Password>:      User password");
      System.out.println ("<Table name>:    Table to print");
      System.out.println ("<Geo column>:    Name of geometry colum,");
      System.out.println ("<Predicate>:     WHERE clause");
      System.out.println ("<Print Style>:   0=none, 1=raw, 2=format, 4=details");
      System.out.println ("<Fast Unpickle>: 0=no, 1=yes");
      return;
    }

    String  connectionString  = args[0];
    String  userName          = args[1];
    String  userPassword      = args[2];
    String  tableName         = args[3];
    String  geoColumn         = args[4];
    String  predicate         = args[5];
    int     printStyle        = Integer.parseInt(args[6]);
    boolean fastUnpickle      = (args.length > 7 ? (Integer.parseInt(args[7])==1) : false);

    // Register the Oracle JDBC driver
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

    // Get a connection to the database
    System.out.println ("Connecting to database '"+connectionString+"'");
    Connection dbConnection = DriverManager.getConnection(connectionString,
      userName, userPassword);
    System.out.println ("Got a connection: "+dbConnection.getClass().getName());

    // Perform the database query
    printGeometries(dbConnection, tableName, geoColumn, predicate, printStyle, fastUnpickle);

    // Close database connection
    dbConnection.close();
  }

  static void printGeometries(Connection dbConnection, String tableName,
    String geoColumn, String predicate,int printStyle, boolean fastUnpickle)
    throws Exception
  {
    long totalMs = 0,
         loadGeomMs = 0;
    long start, end;
    long totalPoints = 0;
    long totalElems = 0;
    long totalSize = 0;
    JGeometry geom;

    totalMs = System.currentTimeMillis();

    // Construct SQL query
    String sqlQuery = "SELECT " + geoColumn + " FROM " + tableName + " "
      + predicate;
    System.out.println ("Executing query: '"+sqlQuery+"'");

    // Execute query
    Statement stmt = dbConnection.createStatement();
    ResultSet rs = (ResultSet) stmt.executeQuery(sqlQuery);

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

      if (printStyle > 0) {
        System.out.println ("Geometry # " + rowNumber + ":");
        printGeometry(geom, printStyle);
      }

      totalSize += geom.getSize();
      totalPoints += geom.getNumPoints();

    }
    stmt.close();
    System.out.println("");
    System.out.println("Done - "+rowNumber+" geometries extracted");
    System.out.println(" " + totalPoints + " vertices");
    System.out.println(" " + totalSize + " bytes");
    System.out.println("");
    totalMs = System.currentTimeMillis() - totalMs;
    System.out.println("Elapsed:          " + totalMs + " ms");
    System.out.println("Getting Objects:  " + loadGeomMs + " ms");
  }

  static void printGeometry(JGeometry geom, int printStyle)
    throws Exception
  {
    // extract details from jGeometry object
    int gType =               geom.getType();
    int gSRID =               geom.getSRID();
    int gDimensions =         geom.getDimensions();
    long gNumPoints =         geom.getNumPoints();
    long gSize =              geom.getSize();
    boolean isPoint =         geom.isPoint();
    boolean isCircle =        geom.isCircle();
    boolean hasCircularArcs = geom.hasCircularArcs();
    boolean isGeodeticMBR =   geom.isGeodeticMBR();
    boolean isLRSGeometry =   geom.isLRSGeometry();
    boolean isMultiPoint =    geom.isMultiPoint();
    boolean isRectangle =     geom.isRectangle();

    // point
    double gPoint[]  =        geom.getPoint();
    // element info array
    int gElemInfo[] =         geom.getElemInfo();
    int gNumElements =        (gElemInfo == null ? 0 : gElemInfo.length / 3);
    // ordinates array
    double gOrdinates[] =     geom.getOrdinatesArray();

    // other information
    double[] gFirstPoint =    geom.getFirstPoint();
    double[] gLastPoint =     geom.getLastPoint();
    Point2D gLabelPoint =     geom.getLabelPoint();
    Point2D gJavaPoint =      geom.getJavaPoint();
    Point2D[] gJavaPoints =   (isMultiPoint ? geom.getJavaPoints():null);
    double[] gMBR =           geom.getMBR();
    Shape gShape =            geom.createShape();

    // Print out geometry in "raw" (toStringFull) format
    if ((printStyle & 1) == 1 )
      System.out.println (geom.toStringFull());

    // Print out geometry in SDO_GEOMETRY format
    if ((printStyle & 2) == 2 )
      System.out.println (formatGeometry(geom));

    // Print out geometry details
    if ((printStyle & 4) == 4) {
      System.out.println (" Type:            " + gType);
      System.out.println (" SRID:            " + gSRID);
      System.out.println (" Dimensions:      " + gDimensions);
      System.out.println (" NumPoints:       " + gNumPoints);
      System.out.println (" Size:            " + gSize);
      System.out.println (" isPoint:         " + isPoint);
      System.out.println (" isCircle:        " + isCircle);
      System.out.println (" hasCircularArcs: " + hasCircularArcs);
      System.out.println (" isGeodeticMBR:   " + isGeodeticMBR);
      System.out.println (" isLRSGeometry:   " + isLRSGeometry);
      System.out.println (" isMultiPoint:    " + isMultiPoint);
      System.out.println (" isRectangle:     " + isRectangle);
      System.out.println (" MBR:             ("
          + gMBR[0] + " " + gMBR[1] + ") (" + gMBR[2] + " " + gMBR[3] + ") ");
      System.out.println (" First Point:     " + formatPoint(gFirstPoint));
      System.out.println (" Last Point:      " + formatPoint(gLastPoint));
      System.out.println (" Label Point:     " + formatPoint(gLabelPoint));
      System.out.println (" Point:           " + formatPoint(gPoint));
      System.out.println (" Java Point:      " + formatPoint(gJavaPoint));
      System.out.println (" Java Points List: " +
        (gJavaPoints==null ? "NULL": "["+gJavaPoints.length+"]"));
      if (gJavaPoints != null)
        for (int i=0; i<gJavaPoints.length; i++)
          System.out.println ("   ["+(i+1)+"] (" +
            gJavaPoints[i].getX() + ", " +
            gJavaPoints[i].getY() +")");

      // Get 3D-specific information
      if (geom.getDimensions() == 3) {
        J3D_Geometry geom3D = new J3D_Geometry (
           geom.getType(), geom.getSRID(),
           geom.getElemInfo(), geom.getOrdinatesArray()
        );
        System.out.println (" Length:          " + geom3D.length(1,0.5));
        System.out.println (" Area  :          " + geom3D.area(0.5));
        System.out.println (" Volume:          " + geom3D.volume(0.5));
      }
      JGeometry[] elements = geom.getElements();
      if (elements != null && elements.length>1) {
        System.out.println (" Elements:        "+elements.length);
      }
      System.out.println (" SDO_ELEM_INFO:   [" + gNumElements + " elements]" );
      if (gElemInfo != null)
        for (int i=0; i<gNumElements; i++)
          System.out.println ("   ["+(i+1)+"] (" +
            gElemInfo[i*3] + ", " +
            gElemInfo[i*3+1] + ", " +
            gElemInfo[i*3+2] + ")");

      System.out.println (" SDO_ORDINATES:   [" + gNumPoints + " vertices]" );
      if (gOrdinates != null)
        for (int i=0; i<gNumPoints; i++) {
          System.out.print ("   ["+(i+1)+"] (");
          for (int j=0; j<gDimensions; j++) {
            System.out.print (gOrdinates[i*gDimensions+j]);
            if (j<gDimensions-1)
              System.out.print (", ");
          }
          System.out.println (")");
        }
    }

    /*
    // Recursively print elements
    JGeometry[] elements = geom.getElements();
    if (elements != null && elements.length>1) {
      System.out.println ("Number of elements: "+elements.length);
      for (int i=0; i<elements.length; i++) {
        if (printStyle > 0) {
          System.out.println ("Element ["+(i+1)+"]");
          printGeometry (elements[i], printStyle);
        }
      }
    }
    */

  }

  static String formatPoint(double[] point)
  {
    String formattedPoint;
    if (point == null)
      formattedPoint = "NULL";
    else {
      formattedPoint = "["+point.length + "] (";
      for (int i=0; i<point.length; i++) {
        formattedPoint += point[i];
        if (i < point.length-1)
          formattedPoint += ", ";
      }
      formattedPoint += ")";
    }
    return (formattedPoint);
  }

  static String formatPoint(Point2D point)
  {
    String formattedPoint;
    if (point == null)
      formattedPoint = "NULL";
    else
      formattedPoint = "[2] (" + point.getX() + ", " + point.getY() + ")";
    return (formattedPoint);
  }

 static String formatGeometry (JGeometry geom)
  {
    String fg;

    // extract details from jGeometry object
    int gType =               geom.getType();
    int gSRID =               geom.getSRID();
    int gDimensions =         geom.getDimensions();
    boolean isPoint =         geom.isPoint();
    // point
    double gPoint[]  =        geom.getPoint();
    // element info array
    int gElemInfo[] =         geom.getElemInfo();
    // ordinates array
    double gOrdinates[] =     geom.getOrdinatesArray();

    // Format jGeometry in SDO_GEOMETRY format
    int sdo_gtype = gDimensions * 1000 + gType;
    int sdo_srid  = gSRID;

    fg = "SDO_GEOMETRY(" + sdo_gtype + ", ";
    if (sdo_srid == 0)
      fg = fg + "NULL, ";
    else
      fg = fg + sdo_srid + ", ";
    if (gPoint == null)
      fg = fg + "NULL, ";
    else {
      fg = fg + "SDO_POINT_TYPE(" + gPoint[0]+", "+gPoint[1]+", ";
      if (gPoint.length < 3)
        fg = fg + "NULL), ";
      else if (java.lang.Double.isNaN(gPoint[2]))
        fg = fg + "NULL), ";
      else
        fg = fg + gPoint[2]+"), ";
    }
    if (!isPoint & gElemInfo != null) {
      fg = fg + "SDO_ELEM_INFO_ARRAY( ";
      for (int i=0; i<gElemInfo.length-1; i++)
        fg = fg +  gElemInfo[i]+", ";
      fg = fg +  gElemInfo[gElemInfo.length-1] + "), ";
    }
    else
      fg = fg + "NULL, ";
    if (!isPoint & gOrdinates != null) {
      fg = fg + "SDO_ORDINATE_ARRAY( ";
      for (int i=0; i<gOrdinates.length-1; i++)
        fg = fg +  gOrdinates[i]+", ";
      fg = fg +  gOrdinates[gOrdinates.length-1] + ")";
    }
    else
      fg = fg + "NULL";
    fg = fg + ")";

    return (fg);
  }
}
