<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--

This is an application that illustrates how to integrate various
features of Oracle Spatial into a web-based application.

It supports the following actions

- display of a base map showing street-level information
- overlay the map with business data (customers, branches, and competitors)
- zoom, pan, and recenter the map
- select a customer, branch, or competitor and display details
- enter a street address and center the map on that address
- set location marks using mouse clicks
- find all customers (or branches or competitors) that are within a chosen distance
  from a location mark or customer (or branch or competitor)
- find the N nearest customers (or branches or competitors) from a location mark
  or customer (or branch or competitor)

The application also shows the SQL queries it sends to the database to do the
"within distance" and "nearest neighbor" searches).

The JSP can be called with parameters to define the initial
map to display: map name, data source, initial center, and size:

  dataSource
  baseMap
  initialCx
  initialCy
  initialSize

In addition, the parameter "debug" adds a display of the XML
requests and responses.

-->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.awt.geom.Point2D" %>
<%@ page import="java.awt.Dimension" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="oracle.lbs.mapclient.MapViewer" %>
<%@ page import="oracle.spatial.geometry.*" %>

<%

  // Constants
  int    mapWidth = 600;              // Map width in pixels
  int    mapHeight = 500;             // Map height in pixels
  String defDataSource = "SPATIAL";   // Default data source name
  String defBaseMap = "US_CITY_MAP";  // Default map name
  double defCx = -122.43302;          // Default origin longitude
  double defCy = 37.7878425;          // Default origin latitude
  double defMapSize = 0.01;           // Initial map size
  double zoomFactor = 1.5;            // Zoom factor
  int    mapSrid = 8307;              // Map coordinate system
  String[] appThemes                  // Application themes
    = new String [] {
      "BRANCHES",
      "COMPETITORS",
      "CUSTOMERS"
    };
  double appThemeMinScale = 0.005;    // Scale at which app themes are displayed
  String[] colsToSelect               // Columns to select for application themes
    = new String[]{
      "ID",
      "NAME",
      "STREET_NUMBER||' '||STREET_NAME ADDRESS",
      "CITY",
      "POSTAL_CODE",
      "STATE",
      "PHONE_NUMBER"
    };
  int numVisibleCols = 7;             // Number of columns to display for searches
  String geoColumn = "LOCATION";      // Name of geometry column in app themes
  double markerMapSize = 0.01;        // Map size of map for address searches
  String markerStyle ="M.YELLOW PIN"; // Style for location mark
  String markerLabelStyle             // Style for address label
    = "T.ADDRESS_MARK_NAME";
  String queryStyle = "M.CYAN PIN";   // Style for query result markers

  // Name of this JSP
  String jspURL = response.encodeURL(request.getRequestURI());

  // URL of MapViewer servlet
  String mapViewerURL  =
    "http://"+ request.getServerName()+":"
      + request.getServerPort()
      + request.getContextPath()+"/omserver";

  // Static request parameters
  String dataSource = null;           // Data source name
  String baseMap = null;              // Map name
  double initialCx = 0;               // Initial Map center X in map coordinates
  double initialCy = 0;               // Initial Map center Y in map coordinates
  double initialSize = 0;             // Initial Map size in map coordinates
  boolean debug = false;              // Debug mode

  // Current map and search parameters
  double cx = 0;                      // Current map center X in map coordinates
  double cy = 0;                      // Current map center Y in map coordinates
  double mapSize = 0;                 // Current map size in map coordinates

  double mapScale = 0;                // Scale of the current map
  String[] checkedThemes;             // List of checked themes
  String identifyTheme;               // Name of theme to identify
  double markX = 0;                   // Mark X
  double markY = 0;                   // Mark Y
  String findAddress;                 // Street address to find
  int nnSearchParam;                  // Number of matches for NN search

  String nnSearchTheme;               // Theme to search for nearest neighbors
  double distSearchParam;             // Distance for within-distance search
  String distSearchTheme;             // Theme to search for within-distance search

  // User action
  String userAction = null;           // User requested action
  String clickAction = null;          // Action to perform on mouse click

  // HTML output
  String imgURL = "";                 // URL of returned map
  String mapRequest = "";             // Map request (XML)
  String mapResponse = "";            // Map response (XML)
  String mapError = "";               // Error or information message
  int featuresFound = 0;              // Number of features found
  String[][] featureInfo = null;      // Attributes of selected features
  String[] geocodeInfo = null;        // Result of geocode operation

  // Load static request parameters
  dataSource = request.getParameter("dataSource");
  if (dataSource != null)
    dataSource = dataSource.toUpperCase();
  else
    dataSource = defDataSource;
  baseMap = request.getParameter("baseMap");
  if (baseMap != null)
    baseMap = baseMap.toUpperCase();
  else
    baseMap = defBaseMap;
  initialCx = request.getParameter("initialCx") != null ?
    Double.valueOf(request.getParameter("initialCx")).doubleValue() : defCx;
  initialCy = request.getParameter("initialCy") != null ?
    Double.valueOf(request.getParameter("initialCy")).doubleValue() : defCy;
  initialSize = request.getParameter("initialSize") != null ?
    Double.valueOf(request.getParameter("initialSize")).doubleValue() : defMapSize;
  debug = request.getParameter("debug") != null ?
    Boolean.valueOf(request.getParameter("debug")).booleanValue(): false;

  // Load dynamic request parameters:

  // - Current location mark
  markX = request.getParameter("markX") != null ?
    Double.valueOf(request.getParameter("markX")).doubleValue() : 0;
  markY = request.getParameter("markY") != null ?
    Double.valueOf(request.getParameter("markY")).doubleValue() : 0;

  // - List of checked themes and theme to identify
  checkedThemes = request.getParameterValues("checkedThemes");
  identifyTheme = request.getParameter("identifyTheme");

  // - Address to find
  findAddress = request.getParameter("findAddress");
  if (findAddress == null)
    findAddress = "";

  // - Nearest neighbor search parameters
  nnSearchParam = request.getParameter("nnSearchParam") != null ?
    Integer.parseInt(request.getParameter("nnSearchParam")) : 1;
  nnSearchTheme = request.getParameter("nnSearchTheme");

  // - Within-distance search parameters
  distSearchParam = request.getParameter("distSearchParam") != null ?
    Double.valueOf(request.getParameter("distSearchParam")).doubleValue() : 500;
  distSearchTheme = request.getParameter("distSearchTheme");

  // Reload MapViewer from session (if present)
  MapViewer mv = (MapViewer) session.getAttribute("MapviewerHandle");

  // Get user action. Default is "Reset"
  userAction = request.getParameter("userAction");
  if (userAction == null || mv == null)
    userAction = "Reset";
  clickAction = request.getParameter("clickAction");
  if (clickAction == null)
    clickAction = "reCenter";
  if (request.getParameter("mapImage.x") != null)
    userAction = clickAction;
  if (request.getParameter("distSearch") != null)
    userAction = "distSearch";
  if (request.getParameter("nnSearch") != null)
    userAction = "nnSearch";
  if (request.getParameter("clearSearch") != null)
    userAction = "Clear Search";
  mapError = userAction;

  // Dispatch and process user action
  if (userAction != null) {

    // -----------------------------------------------------------------------
    // [Reset] button clicked
    // Initialize the MapViewer object with the original center and size
    // -----------------------------------------------------------------------
    if (userAction.equals("Reset")) {

      if (mv == null)
        mapError = "New Session Started";

      // Create and initialize new MapViewer object)
      mv = new MapViewer(mapViewerURL);
      mv.setDataSourceName(dataSource);                     // Data source
      mv.setBaseMapName(baseMap);                           // Base map
      for(int i=0; i<appThemes.length; i++) {               // Additional themes
        mv.addPredefinedTheme(appThemes[i]);                // Theme name
        mv.setThemeScale(appThemes[i],
          appThemeMinScale, 0.0);                           // Scale limits
      }
      mv.setAllThemesEnabled(false);                        // Themes disabled
      mv.setMapTitle("  ");                                 // No title
      mv.setImageFormat(MapViewer.FORMAT_PNG_URL);          // Map format
      mv.setDeviceSize(new Dimension(mapWidth, mapHeight)); // Map size

      // Save MapViewer object in session
      session.setAttribute("MapviewerHandle", mv);

      // Set initial map position and display it
      mv.setCenterAndSize(initialCx, initialCy, initialSize);
      mv.run();

      // Set default options
      clickAction = "reCenter";
      markX = 0;
      markY = 0;
    }

    // -----------------------------------------------------------------------
    // [Zoom XXX] button clicked
    // Zoom in or out by a fixed factor
    // -----------------------------------------------------------------------
    else if (userAction.equals("Zoom In"))
      mv.zoomIn(zoomFactor);
    else if (userAction.equals("Zoom Out"))
      mv.zoomOut(zoomFactor);

    // -----------------------------------------------------------------------
    // [Pan XXX] button clicked
    // Shift map 50% in the desired direction.
    // -----------------------------------------------------------------------
    else if (userAction.equals("Pan W"))
      mv.pan (0, mapHeight/2);
    else if (userAction.equals("Pan N"))
      mv.pan (mapWidth/2, 0);
    else if (userAction.equals("Pan S"))
      mv.pan (mapWidth/2, mapHeight);
    else if (userAction.equals("Pan E"))
      mv.pan (mapWidth, mapHeight/2);

    // -----------------------------------------------------------------------
    // Map clicked to recenter
    // Use the coordinates of the clicked point as new map center
    // -----------------------------------------------------------------------
    else if (userAction.equals("reCenter")) {
      // Extract coordinates of mouse click
      int imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
      int imgCY = Integer.parseInt(request.getParameter("mapImage.y"));
      // Pan to that position
      mv.pan (imgCX, imgCY);
    }

    // -----------------------------------------------------------------------
    // [Update Map] button clicked
    // Enable the themes selected by the user and refresh the map
    // -----------------------------------------------------------------------
    else if (userAction.equals("Update Map")) {
      if (checkedThemes == null)
        mv.setAllThemesEnabled(false);
      else
        mv.enableThemes(checkedThemes);
      mv.run();
    }

    // -----------------------------------------------------------------------
    // Map clicked to set a mark
    // Get the coordinates of the clicked point and use them to set a mark
    // at that point
    // -----------------------------------------------------------------------
    else if (userAction.equals("setMark")) {

      // Extract coordinates of mouse click
      int imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
      int imgCY = Integer.parseInt(request.getParameter("mapImage.y"));

      // Remove any existing marker
      mv.removeAllPointFeatures();

      // Add a marker at the point clicked
      Point2D p = mv.getUserPoint(imgCX,imgCY);
      mv.addPointFeature (p.getX(), p.getY(),
        mapSrid, markerStyle, null, null, null);

      // Save new mark
      markX = p.getX();
      markY = p.getY();

      // Refresh map
      mv.run();
    }

    // -----------------------------------------------------------------------
    // Map clicked to identify a feature.
    // Get the coordinates of the clicked point
    // use them to query the feature from the selected theme
    // -----------------------------------------------------------------------
    else if (userAction.equals("identify")) {

      // Extract coordinates of mouse click
      int imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
      int imgCY = Integer.parseInt(request.getParameter("mapImage.y"));

      if (identifyTheme == null)
        mapError = "No theme selected to identify";
      else if (!mv.getThemeEnabled(identifyTheme))
        mapError = "Theme "+identifyTheme+" is not visible";
      else {

        // Locate the feature and get details
        // Notes:
        //   1. The identify() method needs a TABLE NAME, not a theme name.
        //      We just assume that the theme and table name are the same.
        //   2. We query a rectangle of 4 pixels around the user click. Notice,
        //      however, that pixels have their origin at the UPPER-LEFT corner
        //      of the image, whereas ground coordinates use the LOWER-LEFT
        //      corner.
        String[][] f = mv.identify(dataSource, identifyTheme, colsToSelect,
          geoColumn, mapSrid,
          imgCX-4, imgCY+4,
          imgCX+4, imgCY-4,
          false);

        // The result is one row per matching record, but we want to display
        // results as one column per record.
        if (f!= null && f.length > 0) {
          featureInfo = new String[f[0].length][f.length];
          for (int i=0; i<f.length; i++)
            for (int j=0; j<f[i].length; j++)
              featureInfo[j][i] = f [i][j];
          featuresFound = f.length-1;
        } else
          mapError = "No matching " + identifyTheme + " found";

        if (featuresFound > 0) {

          // Remove any existing marker
          mv.removeAllPointFeatures();

          // Add a marker at the point clicked
          Point2D p = mv.getUserPoint(imgCX,imgCY);
          mv.addPointFeature (p.getX(), p.getY(),
            mapSrid, markerStyle, null, null, null);

          // Save new mark
          markX = p.getX();
          markY = p.getY();

          // Refresh map
          mv.run();
        }
      }
    }

    // -----------------------------------------------------------------------
    // [Clear] button clicked:
    // Remove the mark and refresh map
    // -----------------------------------------------------------------------
    else if (userAction.equals("Clear")) {

      if (markX != 0 || markY != 0) {

        // Clear current address
        findAddress = "";

        // Remove any existing marker
        mv.removeAllPointFeatures();

        // Reset mark
        markX = 0;
        markY = 0;

        // Refresh map
        mv.run();

      }
    }

    // -----------------------------------------------------------------------
    // [Go to Mark] button clicked
    // Center map on mark
    // -----------------------------------------------------------------------
    else if (userAction.equals("Go To Mark")) {
      if (markX == 0 && markY == 0)
        mapError = "No address or mark set";
      else {
        mv.setCenter(markX, markY);
        mv.run();
      }
    }

    // -----------------------------------------------------------------------
    // [Find] button clicked:
    // Geocode the entered address.
    // Center map on the resulting coordinates.
    // Set mark on that point.
    // -----------------------------------------------------------------------
    else if (userAction.equals("Find")) {

      // Extract address details
      String[] addressLines = findAddress.split("\r\n");

      // Construct query to geocoder
      String gcQuery =
        "SELECT "+
        "G.GEO_ADDR.MATCHCODE, G.GEO_ADDR.LONGITUDE, G.GEO_ADDR.LATITUDE, " +
        "G.GEO_ADDR.HOUSENUMBER || ' ' || G.GEO_ADDR.STREETNAME, " +
        "G.GEO_ADDR.SETTLEMENT || ' ' || G.GEO_ADDR.POSTALCODE " +
        "FROM (SELECT SDO_GCDR.GEOCODE(USER ,SDO_KEYWORDARRAY(";
      for (int i=0; i<addressLines.length; i++) {
        gcQuery = gcQuery + "'" + addressLines[i] + "'";
        if (i < addressLines.length-1)
          gcQuery = gcQuery + ",";
      }
      gcQuery = gcQuery + "), 'US', 'DEFAULT') " +
      "GEO_ADDR FROM DUAL) G";

      // Send query
      String[][] f = mv.doQuery(dataSource, gcQuery);

      // Extract match code. Proceed only if > 0
      int matchCode = Integer.parseInt(f[1][0]);
      if (matchCode > 0) {

        // Extract X and Y coordinates from geocode result
        double destX = Double.valueOf(f[1][1]).doubleValue();
        double destY = Double.valueOf(f[1][2]).doubleValue();

        // Extract full street address from result
        String streetAddress = f[1][3];

        // Transform result from row-major to column-major
        geocodeInfo = new String[f[0].length-3];
        for (int i=0; i<f[0].length-3; i++)
          geocodeInfo[i] = f [1][i+3];

        // Center map on the new address and zoom in
        mv.setCenterAndSize(destX, destY, markerMapSize);

        // Remove any existing marker
        mv.removeAllPointFeatures();

        // Add a marker at the point clicked and label it
        // with the first address line
        mv.addPointFeature (
          destX, destY,
          mapSrid,
          markerStyle,
          streetAddress,
          markerLabelStyle,
          null,
          true);

        // Save new mark
        markX = destX;
        markY = destY;

        // Show SQL statement
        mapError = gcQuery;

        // Refresh map
        mv.run();
      }
      else
        mapError = "Address not found";
    }

    // -----------------------------------------------------------------------
    // [distSearch] button clicked
    // Search for all neighbors within distance D from the current set mark.
    // -----------------------------------------------------------------------
    else if (userAction.equals("distSearch")) {
      if (markX == 0 && markY == 0)
        mapError = "No address or mark set";
      else if (!mv.getThemeEnabled(distSearchTheme))
        mapError = "Theme "+distSearchTheme+" is not visible";
      else if (distSearchParam <= 0)
        mapError = "Enter search distance";
      else {

        // Construct spatial query.
        String sqlQuery = "SELECT "+geoColumn+" FROM " + distSearchTheme
          + " WHERE SDO_WITHIN_DISTANCE ("+ geoColumn + ","
          + " SDO_GEOMETRY (2001," + mapSrid + ", SDO_POINT_TYPE("
          + markX + "," + markY + ",NULL), NULL, NULL), "
          + "'DISTANCE="+distSearchParam+" UNIT=M') = 'TRUE'";
        mapError = "Executing query: "+ sqlQuery;

        // Add a JDBC theme to highlight the results of the query
        mv.addJDBCTheme (
          dataSource,                 // Data source
          "SEARCH RESULTS",           // Theme to search
          sqlQuery,                   // SQL Query
          geoColumn,                  // Name of spatial column
          null,                       // srid
          queryStyle,                 // renderStyle
          null,                       // labelColumn
          null,                       // labelStyle
          true                        // passThrough
        );

        // Perform the query
        String[][] f = mv.queryWithinRadius(
          dataSource,                 // Data source
          distSearchTheme,            // Theme to search
          colsToSelect,               // Names of columns to select
          null,                       // Extra condition
          markX, markY,               // Center point (current mark)
          distSearchParam,            // Distance to search
          false                       // Center point is in ground coordinates
        );

        if (f!= null && f.length > 0) {

          // The result is one row per matching record, but we want to display
          // results as one column per record.
          featureInfo = new String[f[0].length][f.length];
          for (int i=0; i<f.length; i++)
            for (int j=0; j<f[i].length; j++)
              featureInfo[j][i] = f [i][j];
          featuresFound = f.length-1;

          // Refresh map
          mv.run();

        } else
          mapError = "No matching " + distSearchTheme + " found";

      }
    }

    // -----------------------------------------------------------------------
    // [nnSearch] button clicked
    // Search the N nearest neighbors from the current set mark.
    // -----------------------------------------------------------------------
    else if (userAction.equals("nnSearch")) {
      if (markX == 0 && markY == 0)
        mapError = "No address or mark set";
      else if (!mv.getThemeEnabled(nnSearchTheme))
        mapError = "Theme "+nnSearchTheme+" is not visible";
      else if (nnSearchParam <= 0)
        mapError = "Enter number of matches to search";
      else {

        // Construct spatial query
        String sqlQuery = "SELECT "+geoColumn+", SDO_NN_DISTANCE(1) DISTANCE"
          + " FROM " + nnSearchTheme
          + " WHERE SDO_NN ("+ geoColumn + ","
          + " SDO_GEOMETRY (2001," + mapSrid + ", SDO_POINT_TYPE("
          + markX + "," + markY + ",NULL), NULL, NULL), "
          + "'SDO_NUM_RES="+nnSearchParam+"',1) = 'TRUE'"
          + " ORDER BY DISTANCE";
        mapError = "Executing query: "+ sqlQuery;

        // Add a JDBC theme to highlight the results of the query
        mv.addJDBCTheme (
          dataSource,                 // Data source
          "SEARCH RESULTS",           // Theme to search
          sqlQuery,                   // SQL Query
          geoColumn,                  // Name of spatial column
          null,                       // srid
          queryStyle,                 // renderStyle
          null,                       // labelColumn
          null,                       // labelStyle
          true                        // passThrough
        );

        // Perform the query
        String[][] f = mv.queryNN(
          dataSource,                 // Data source
          nnSearchTheme,              // Theme to search
          colsToSelect,               // Names of columns to select
          nnSearchParam,              // Number of neighbors
          markX, markY,               // Center point (current mark)
          null,                       // Extra condition
          false,                      // Center point is in ground coordinates
          null
        );

        if (f== null || f.length == 0)
          mapError = "No matching " + nnSearchTheme + " found";
        else {

          // The result is one row per matching record, but we want to display
          // results as one column per record.
          featureInfo = new String[f[0].length][f.length];
          for (int i=0; i<f.length; i++)
            for (int j=0; j<f[i].length; j++)
              featureInfo[j][i] = f [i][j];
          featuresFound = f.length-1;

          // Refresh map
          mv.run();
        }
      }
    }

    // -----------------------------------------------------------------------
    // [Clear Search] button
    // Clear search results
    // -----------------------------------------------------------------------
    else if (userAction.equals("Clear Search")) {

      // Remove the markers of the matching results
      mv.deleteTheme ("SEARCH RESULTS");

      // Refresh map
      mv.run();
    }

    // Update size and center on screen with new values
    mapSize = mv.getSize();
    Point2D center = mv.getCenter();
    cx = center.getX();
    cy = center.getY();
    mapScale = mv.getMapScale();

    // Get URL to generated Map
    imgURL = mv.getGeneratedMapImageURL();

    // Get the XML request sent to the server
    mapRequest = mv.getMapRequestString();

    // Get the XML response received from the server
    mapResponse = mv.getMapResponseString();
  }

%>

<!-- Output the HTML content -->

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Pro Oracle Spatial for Oracle Database 11g - Sample JSP Application</title>
  <link rel="stylesheet" href="SampleApplication.css" type="text/css">
  <script language="JavaScript" type="text/javascript">

    function CheckAll()
    {
      var tl = document.viewerForm;
      var len = tl.elements.length;
      for (var i = 0; i < len; i++) {
        var e = tl.elements[i];
        if (e.name == "checkedThemes") {
          e.checked = true;
        }
      }
    }

    function ClearAll()
    {
      var tl = document.viewerForm;
      var len = tl.elements.length;
      for (var i = 0; i < len; i++) {
        var e = tl.elements[i];
        if (e.name == "checkedThemes") {
          e.checked = false;
        }
        if (e.name == "identifyTheme") {
          e.checked = false;
        }
      }
    }

  </script>
</head>
<body>
<form name="viewerForm" method="post" action="<%= jspURL %>">
<table>
  <tr>
    <td width="300" valign="top" align="left">

      <!-- Searches -->
      <table>

        <!-- Find Address -->
        <tr><td>
          <font color="green"><b>Find address:</b></font>
        </td></tr>
        <tr>
          <td align="left">
            <textarea
              name="findAddress" rows="2" cols="35"
              wrap><%= findAddress%></textarea>
          </td>
        </tr>
        <tr>
          <td align="center">
            <input type="submit" name="userAction" value="Find">
            <input type="submit" name="userAction" value="Clear">
          </td>
        </tr>
        <tr><td><hr></td></tr>

        <!-- Show Location mark -->
        <tr><td>
          <font color="green"><b>Location Mark:</b></font>
        </td></tr>
        <tr>
          <td>
          <table>
            <tr>
              <td width="300">
                <table>
                  <tr><td><b><font size="-1">Longitude:</font></b></td>
                  <td><font size="-1"><%= markX %></font></td></tr>
                  <tr><td><b><font size="-1">Latitude: </font></b></td>
                  <td><font size="-1"><%= markY %></font></td></tr>
                </table>
              </td>
          </td>
          <td>
            <input type="submit" name="userAction" value="Clear">
          </td>
          </table>
        </tr>
        <tr><td><hr></td></tr>

        <!-- Within Distance Search -->
        <tr><td>
          <font color="green"><b>Search from Location Mark</b></font>
        </td></tr>
        <tr><td><font size="-1"><b>
          <% if (appThemes !=null && appThemes.length>0) {%>
            <select name="distSearchTheme">
            <% for (int i=0; i<appThemes.length; i++) {%>
              <option <%=appThemes[i].equals(distSearchTheme)?"selected":""%>>
                <%= appThemes[i].toUpperCase() %>
              </option>
            <% } %>
            </select>
          <% } %>
          within
          <input type="text" name="distSearchParam"
            value="<%= distSearchParam %>" size="2"/>
          meters
          </b></font>
        </td></tr>
        <tr><td align="center">
        <input type="submit" name="distSearch" value="Find">
        <input type="submit" name="clearSearch" value="Clear">
        </td></tr>
        <tr><td><hr></td></tr>

        <!-- Nearest Neighbor Search -->
        <tr><td>
          <font color="green"><b>Find nearest from Location Mark</b></font>
        </td></tr>
        <tr><td><font size="-1"><b>
          <input type="text" name="nnSearchParam"
            value="<%= nnSearchParam %>" size="2"/>
          nearest
          <% if (appThemes !=null && appThemes.length>0) {%>
            <select name="nnSearchTheme">
            <% for (int i=0; i<appThemes.length; i++) {%>
              <option <%=appThemes[i].equals(nnSearchTheme)?"selected":""%>>
                <%= appThemes[i].toUpperCase() %>
              </option>
            <% } %>
            </select>
          <% } %>
          </b></font>
        </td></tr>
        <tr><td align="center">
        <input type="submit" name="nnSearch" value="Find">
        <input type="submit" name="clearSearch" value="Clear">
        </td></tr>
        <tr><td><hr></td></tr>

        <!-- Click action -->
        <tr><td>
          <font color="green"><b>Click on the map to:</b></font>
        </td></tr>
        <tr>
          <td>
            <font size="-1">
            <input type="radio" name="clickAction" value="reCenter"
              <%= clickAction.equals("reCenter")?"checked":""%> >
              <B>Recenter</B>
            <input type="radio" name="clickAction" value="identify"
              <%= clickAction.equals("identify")?"checked":""%> >
              <B>Identify</B>
            <input type="radio" name="clickAction" value="setMark"
              <%= clickAction.equals("setMark")?"checked":""%> >
              <B>Mark</B>
            </font>
          </td>
        </tr>

      </table>

    <td width="300" valign="top" align="center">

      <!-- Map display and controls -->
      <table>

        <!-- Map Image -->
        <tr>
          <td align="center" width="<%= mapWidth %>" height="<%= mapHeight %>" >
            <input type="image"
              border="1"
              name="mapImage"
              src="<%= imgURL %>"
              width="<%= mapWidth %>"
              height="<%= mapHeight %>"
              alt="Click to re-center, mark or identify">
          </td>
        </tr>

        <!-- Navigation buttons -->
        <tr>
          <td align="center">
            <table>
              <tr>
                <td align="center">
                <input type="submit" name="userAction" value="Pan N">
                <input type="submit" name="userAction" value="Pan S">
                <input type="submit" name="userAction" value="Pan E">
                <input type="submit" name="userAction" value="Pan W">
                </td>
              </tr>
              <tr>
                <td align="center">
                <input type="submit" name="userAction" value="Zoom In">
                <input type="submit" name="userAction" value="Zoom Out">
                <input type="submit" name="userAction" value="Reset">
                <input type="submit" name="userAction" value="Go To Mark">
                </td>
              </tr>
            </table>
          </td>
        </tr>

      </table>
    </td>

    <td valign="top">
      <table>
        <tr>
          <!-- Theme selection -->
          <td>
           <% String[] ts = mv.getThemeNames();
              if (ts != null) { %>

               <font color="green">
               <b>Select information to include on map</b></font>
               <table>
                 <tr>
                   <td><input type="button" value="Check All"
                     onClick="CheckAll()"></td>
                   <td><input type="button" value="Clear All"
                     onClick="ClearAll()"></td>
                   <td><input type="submit" value="Update Map"
                     name="userAction"></td>
                 </tr>
               </table>
               <font color="#FF0000" size="-1"><b>
               <table>
                 <tr>
                   <td>
                     <table>
                     <% for(int i=0; i<ts.length; i++) {%>
                       <tr><td>
                       <input type="radio"
                          name="identifyTheme"
                          value="<%=ts[i]%>"
                          <%=ts[i].equals(identifyTheme)?"checked":""%> >
                       <input type="checkbox"
                          name="checkedThemes"
                          value="<%=ts[i]%>"
                          <%=mv.getThemeEnabled(ts[i])?"checked":""%> >
                       <% if(!ts[i].equals("SEARCH RESULTS")) { %>
                         <img src="<%=mapViewerURL%>?sty=M.<%=ts[i]%>&ds=<%=dataSource%>&f=png&w=12&h=12&aa=true">
                       <% } %>
                       <font size="-1"><b>
                       <%= ts[i] %>
                       </font></b>
                       </td></tr>
                     <%}%>
                     </table>
                   </td>
                 </tr>
               </table>
           <%}%>
          </td>
        </tr>
        <tr><td><hr></td></tr>
        <tr>
          <td>

          <!-- Identification result -->
          <% if (featureInfo !=null && featureInfo.length>0) {%>
            <tr><td><font color="green"><b>Identification result(s):
              <%= featuresFound %> match(es) </b></font></td></tr>
            <tr><td>
            <div style="overflow: auto; clip: rect(auto, auto, auto, auto);" >
            <table border="1">
              <% for (int i=0; i<numVisibleCols; i++) {%>
                <tr>
                <% String[] row = featureInfo[i];
                   for (int k=0; k<row.length; k++) {%>
                    <td>
                    <% if (k==0) {%><b><% } %>
                    <font size="-1"><%= row[k] %></font>
                    <% if (k==0) {%></b><% } %>
                    </td>
                   <% } %>
                </tr>
              <% } %>
            </table>
            </div>
            </td></tr>
          <% } %>

          <!-- Geocode result -->
          <% if (geocodeInfo !=null && geocodeInfo.length>0) {%>
            <tr><td><font color="green"><b>Address found:</b>
            </font></td></tr>
            <tr><td>
            <table>
              <% for (int i=0; i<geocodeInfo.length; i++) {%>
                <tr><td><font size="-1"><%= geocodeInfo[i] %></font></td></tr>
              <% } %>
            </table>
            </td></tr>
          <% } %>

          </td>
        </tr>
      </table>
    </td>
  </tr>

 <!-- Error messages  -->
 <tr><td colspan="3" style="background-color:lightgrey;"><font color="black"><b><%= mapError %></b></font></td></tr>

  <!-- Map Status -->
  <tr><td colspan="3">
  <font size="-1">
    <b>Data Source:</b>&nbsp;<%= dataSource %>&nbsp;&nbsp;&nbsp;&nbsp;
    <b>Map:</b>&nbsp;<%= baseMap %>&nbsp;&nbsp;&nbsp;&nbsp;
  </font></td></tr>
  <tr><td colspan="3">
  <font size="-1">
    <b>Longitude:</b>&nbsp;<%= cx %>&nbsp;&nbsp;
    <b>Latitude:</b>&nbsp;<%= cy %>&nbsp;&nbsp;
    <b>Size:</b>&nbsp;<%= mapSize %>
    <b>Scale:</b>&nbsp;<%= mapScale %>
  </font></td></tr>

  <!-- XML request and response -->
  <% if (debug) { %>
  <tr><td><b>XML Request:</b></td></tr>
  <tr>
    <td colspan="3" align="left">
      <textarea rows="6" cols="80" wrap readonly><%=mapRequest%>
      </textarea>
    </td>
  </tr>
  <tr><td><b>XML Response:</b></td></tr>
  <tr>
    <td colspan="3" align="left">
      <textarea rows="6" cols="80" wrap readonly><%=mapResponse%></textarea>
    </td>
  </tr>
  <% } %>
</table>

<SCRIPT language=JavaScript>
<!--
if (document.all) {
    document.all("mapImage").style.cursor = 'crosshair';
}
//-->
</SCRIPT>
<input type="hidden" name="markX" value="<%= markX %>">
<input type="hidden" name="markY" value="<%= markY %>">
<input type="hidden" name="debug" value="<%= debug %>">
<input type="hidden" name="dataSource" value="<%= dataSource %>">
<input type="hidden" name="baseMap" value="<%= baseMap %>">
</form>
</body>
</html>
