<%--

This JSP illustrates the use of the Java interface to Mapviewer.

The logic is similar to the SimpleViewerJava example:

It lets you enter the name of a datasource and a map defined in that
data source, and choose a center point and size for the resulting map.
Navigation buttons let you zoom and pan.

Clicking on the map will either recenter it on that point or select a
feature at that point.

The application also lets you select the themes that should appear on the
map, and choose which of the themes should be used for identification.

Finally, an SQL entry box lets you enter any SQL statement. The results
of the query are added to the map as an additional theme.

For each action, the following steps take place:

- get the parameters of the new map request from the user input
- create a Mapviewer object and initialize it based on those parameters
- call the run() method of the object
- update the HTML page with the URL of the new map.

Two additional text areas (read only) show the XML request sent to the server
and the XML response received from the server.

--%>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.awt.geom.Point2D" %>
<%@ page import="java.awt.Dimension" %>
<%@ page import="oracle.lbs.mapclient.MapViewer" %>

<%

    // Name of this JSP
  String jspURL = response.encodeURL(request.getRequestURI());

  // Dynamic request parameters
  String userAction = null;           // User requested action
  String mapViewerURL = null;         // URL of Mapviewer servlet
  String dataSource = null;           // Data source name
  String baseMap = null;              // Map name
  String mapTitle = "";               // Map title
  double cx = 0;                      // Map center X in map coordinates
  double cy = 0;                      // Map center Y in map coordinates
  double mapSize = 0;                 // Map size (height) in map coordinates
  String[] checkedThemes;             // List of checked themes
  String identifyTheme;               // Name of theme to identify
  String sqlQuery = "";               // SQL Query
  String clickAction = null;          // Action to perform on mouse click

  // Other variables
  double mapScale = 0;                // Scale of the current map
  int    imgCX = 0;                   // Map center X in image coordinates
  int    imgCY = 0;                   // Map center Y in image coordinates
  String imgURL = "";                 // URL of returned map
  String mapRequest = "";             // Map request (XML)
  String mapResponse = "";            // Map response (XML)
  String mapMessage = "";             // Error or information message
  int    mapWidth = 480;              // Map width in pixels
  int    mapHeight = 400;             // Map height in pixels
  int    inputSize = 24;
  String[][] featureInfo = null;      // Stores identified feature attributes

  // Load input parameters

  userAction = request.getParameter("userAction");
  clickAction = request.getParameter("clickAction");
  if (clickAction == null)
    clickAction = "recenter";
  if (request.getParameter("mapImage.x") != null)
    userAction = clickAction;

  mapViewerURL = request.getParameter("mapViewerURL");
  if (mapViewerURL == null)
    mapViewerURL = "http://"+ request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/omserver";

  dataSource = request.getParameter("dataSource");
  if (dataSource == null)
    dataSource = "spatial";

  mapTitle = request.getParameter("mapTitle");
  if (mapTitle ==null)
    mapTitle = "";

  baseMap = request.getParameter("baseMap");
  if (baseMap == null)
    baseMap = "world_map";

  sqlQuery = request.getParameter("sqlQuery");

  checkedThemes = request.getParameterValues("checkedThemes");

  identifyTheme = request.getParameter("identifyTheme");

  cx = request.getParameter("cx") != null ?
    Double.valueOf(request.getParameter("cx")).doubleValue() : 0.0;
  cy = request.getParameter("cy") != null ?
    Double.valueOf(request.getParameter("cy")).doubleValue() : 0.0;
  mapSize = request.getParameter("mapSize") != null ?
    Double.valueOf(request.getParameter("mapSize")).doubleValue() : 180;

  // Fetch saved Mapviewer object from session (if any)
  MapViewer mv = (MapViewer) session.getAttribute("mvhandleSpatialViewer");
  if (mv == null) {
    // Create and initialize new Mapviewer object)
    mv = new MapViewer(mapViewerURL);
    mv.setDataSourceName(dataSource);               // Data source
    mv.addThemesFromBaseMap(baseMap);               // Themes from base map
    mv.setAllThemesEnabled(true);                   // Enable all themes
    mv.setMapTitle(" ");                            // No title
    mv.setImageFormat(MapViewer.FORMAT_PNG_URL);    // Map format
    mv.setDeviceSize(                               // Set map size
      new Dimension(mapWidth, mapHeight));
    session.setAttribute("mvhandleSpatialViewer", mv);
    checkedThemes = mv.getThemeNames();             // All themes initially checked
  }

  // Handle user action from form
  try {
    if (userAction != null) {

      /*
         Process user action:
         - Get Map:
           Get a new map or refresh existing map
         - Zoom/Pan:
           zoom or pan button clicked
         - recenter/identify
           user clicked on map
         - Execute Query:
           new SQL query entered
         - Clear Query
           clear the SQL query and the displayed results.
      */

      if (userAction.equals("Reset")) {
        // User pushed the 'Reset' button
        mv = null;
        session.setAttribute("mvhandle", mv);
        checkedThemes = null;
        clickAction = "recenter";
        sqlQuery = "";
      }

      else {

        if (userAction.equals("Get Map")) {
          // User pushed the 'Get Map' button and
          // choose a new datasource or map name,
          // or manually entered a new map center and size
          // Nothing to do: new settings already
          // extracted from request parameters
        }

        // User clicked one of the 'Zoom' buttons:
        // Zoom in or out by a fixed factor (2x)
        else if (userAction.equals("Zm In"))
          mapSize = mapSize/2;
        else if (userAction.equals("Zm Out"))
          mapSize = mapSize*2;

        // User clicked one of the 'Pan' buttons:
        // shift map 50% in the desired direction.
        else if (userAction.equals("Pan W."))
          cx = cx - mapSize/2;
        else if (userAction.equals("Pan N."))
          cy = cy + mapSize/2;
        else if (userAction.equals("Pan S."))
          cy = cy - mapSize/2;
        else if (userAction.equals("Pan E."))
          cx = cx + mapSize/2;

        // User clicked on the map to recenter.
        // Get the coordinates of the clicked point
        // convert to map coordinates, and use it as new map center
        else if (userAction.equals("recenter")) {
          imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
          imgCY = Integer.parseInt(request.getParameter("mapImage.y"));
          Point2D p = mv.getUserPoint(imgCX,imgCY);
          cx = p.getX();
          cy = p.getY();
        }

        // User clicked on the map to identify a feature.
        // Get the coordinates of the clicked point
        // use it to query the feature from the selected theme
        else if (userAction.equals("identify")) {
          imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
          imgCY = Integer.parseInt(request.getParameter("mapImage.y"));
          String[] colsToSelect = new String[]{"*"};
          if (identifyTheme == null)
            mapMessage = "Select theme to identify";
          else {
            // Locate the feature and get details
            featureInfo = mv.queryAtPoint (
              dataSource,              // Datasource
              identifyTheme,           // Theme name
              colsToSelect,            // Names of columns to select
              imgCX, imgCY,            // Mouse click
              null,                    // No extra conditions
              true);                   // Coords are in pixels

            // Add a marker at the point clicked
            mv.removeAllPointFeatures();
            Point2D p = mv.getUserPoint(imgCX,imgCY);
            mv.addPointFeature (p.getX(), p.getY(), 8307,"M.CYAN PIN", null, null, null);
          }
        }

        else if (userAction.equals("Clear Query")) {
          sqlQuery = "";
          mv.deleteTheme ("[SQL_QUERY]");
          mv.deleteStyle ("SQL_QUERY");
        }

        // Construct map request
        mv.setCenterAndSize(cx, cy, mapSize);           // Set center and size of new map

        // If necessary, run the SQL query entered by the user
        if (sqlQuery != null && sqlQuery.length() > 0) {

          // Add style for overlay if needed
          if (!mv.styleExists ("SQL_QUERY"))
            mv.addColorStyle (
              "SQL_QUERY",                // Style name
              "red",                      // Stroke color
              "red",                      // Fill color
              255,                        // Stroke opacity
              40);                        // Fill opacity

          // Add a JDBC theme for the query
          mv.addJDBCTheme (
              dataSource,                 // dataSource
              "[SQL_QUERY]",              // Theme name
              sqlQuery.replace(';',' '),  // SQL Query (remove trailing semi-colon if any)
              null,                       // Name of spatial column
              null,                       // srid
              "SQL_QUERY",                // renderStyle
              null,                       // labelColumn
              null,                       // labelStyle
              true);                      // passThrough
        }

        // Enable the themes selected by the user
        if (checkedThemes != null)
          mv.enableThemes(checkedThemes);
        else
          mv.setAllThemesEnabled(false);

        // If a new SQL query was submitted, enable the SQL_QUERY theme
        if (userAction.equals("Execute Query"))
          mv.setThemeEnabled(true, "[SQL_QUERY]");

        // Get the map
        mv.run();

        // Get URL to generated Map
        imgURL = mv.getGeneratedMapImageURL();

        // Get the XML request sent to the server
        mapRequest = mv.getMapRequestString();

        // Get the XML response received from the server
        mapResponse = mv.getMapResponseString();

        // Get size and center of new map
        mapSize = mv.getSize();
        Point2D center = mv.getCenter();
        cx = center.getX();
        cy = center.getY();

        // Get the scale of the map
        mapScale = mv.getMapScale();
      }
    }
  } catch (Exception e) {
     mapMessage = "Request failed: "+ e.toString();
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Oracle Spatial Viewer</title>
  <link rel="stylesheet" href="my.css" type="text/css">
<script language="JavaScript" type="text/javascript">
<!--

  function checkForm() {
    if (document.viewerForm.mapViewerURL.value=="" ||
        document.viewerForm.dataSource.value=="" ) {
      alert("You can't leave Map Viewer URL and/or Data Source empty.")
      return false
    }
    var fpValue = Number(document.viewerForm.cx.value)
    if (isNaN(fpValue)) {
      alert("Try entering Center of X Coord. again.")
      return false
    }
    fpValue = Number(document.viewerForm.cy.value)
    if (isNaN(fpValue)) {
      alert("Try entering Center of Y Coord. again.")
      return false
    }
    fpValue = Number(document.viewerForm.mapSize.value)
    if (isNaN(fpValue) || fpValue==0) {
      alert("Try entering Size again.")
      return false
    }
    return true
  }

  function clearForm() {
    document.viewerForm.mapViewerURL.value="<%= mapViewerURL %>"
    document.viewerForm.dataSource.value=""
    document.viewerForm.baseMap.value=""
    document.viewerForm.cx.value="0.0"
    document.viewerForm.cy.value="0.0"
    document.viewerForm.mapSize.value="0.0"
    document.viewerForm.sqlQuery.value=""
    document.viewerForm.mapRequest.value=""
    document.viewerForm.clickAction.value="recenter"
    return false
  }

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

//-->
</script>
</head>
<body>
<noscript>
<b>Your browser has JavaScript turned off.</b><br>
You won't able to clear the text fields in the window.
<hr>
</noscript>
<!-- Output the HTML content -->
<h1><center><font color="#449922">Oracle Spatial Viewer</font></center></h1>

<form name="viewerForm" method="post" action="<%= jspURL %>">

<table border="0" cellpadding="0" cellspacing="0">
  <tr>

    <!-- Map selection  -->
    <td valign="top">
      <table border="0">
        <tr><td><font color="#449922" size="+1"><b>Select map to display</b></font><br></td></tr>
        <tr><td><b>Data Source:</b></td></tr>
        <tr><td><input type="text" name="dataSource" value="<%= dataSource %>" size="<%= inputSize %>"/></td></tr>
        <tr><td><b>Base Map:</b></td></tr>
        <tr><td><input type="text" name="baseMap" value="<%= baseMap %>" size="<%= inputSize %>"/></td></tr>
        <tr><td><b>Map Center X Coord:</b></td></tr>
        <tr><td><input type="text" name="cx" value="<%= cx %>" size="<%= inputSize %>"/></td></tr>
        <tr><td><b>Map Center Y Coord:</b></td></tr>
        <tr><td><input type="text" name="cy" value="<%= cy %>" size="<%= inputSize %>"/></td></tr>
        <tr><td><b>Map Size:</b></td></tr>
        <tr><td><input type="text" name="mapSize" value="<%= mapSize %>" size="<%= inputSize %>"
             onFocus= "window.status='Map size in unit of map coordinates';return true"/></td></tr>
        <tr><td align="center">
           <input type="submit" name="userAction" value="Get Map" onClick="return checkForm()" alt="Get new map">
           <input type="submit" name="userAction" value="Reset" onClick="clearForm()">
          </td></tr>
        <tr><td><font color="#449922" size="+1"><b>Click on the map to:</b></font><br></td></tr>
        <tr><td>
          <input type="radio" name="clickAction" value="recenter" <%= clickAction.equals("recenter")?"checked":""%> ><B>Re-center</B>
          <input type="radio" name="clickAction" value="identify" <%= clickAction.equals("identify")?"checked":""%> ><B>Identify</B>
        </td></tr>
        <tr><td><font color="#449922" size="+1"><b>Map Scale:</b></font></td></tr>
        <tr><td><%= mapScale %></td></tr>
      </table>
    </td>

    <td valign="top">
     <table border="0" cellpadding="0" cellspacing="0">

      <!-- Map display  -->
      <tr>
        <td valign="top" align="left" width="<%= mapWidth+20 %>" height="<%= mapHeight %>" >
          <% if (imgURL.trim().length()!=0) { %>
            <input type="image"
              border="1"
              name="mapImage"
              src="<%= imgURL %>"
              width="<%= mapWidth %>"
              height="<%= mapHeight %>"
              alt="Click to re-center or identify">
          <% } else { %>
            <image
              border="1"
              name="mapImage"
              width="<%= mapWidth %>"
              height="<%= mapHeight %>"
              alt="Map Image" >
          <% } %>
        </td>
      </tr>

      <!-- Map navigation buttons  -->
      <tr>
        <td align="center">
          <table>
            <tr>
              <td><input type="submit" name="userAction" value="Zm In">  </td>
              <td><input type="submit" name="userAction" value="Zm Out"> </td>
              <td><input type="submit" name="userAction" value="Pan W."> </td>
              <td><input type="submit" name="userAction" value="Pan N."> </td>
              <td><input type="submit" name="userAction" value="Pan S."> </td>
              <td><input type="submit" name="userAction" value="Pan E."> </td>
            </tr>
          </table>
        </td>
      </tr>

     </table>
    </td>

    <!-- Theme selection -->
    <td valign="top">
      <% if (mv != null) {
           String[] ts = mv.getThemeNames();
           if (ts != null) { %>

            <font color="#449922" size="+1"><b>Select themes to include on map</b></font><br>
            <table>
              <tr>
                <td><input type="button" value="Check All" onClick="CheckAll()"></td>
                <td><input type="button" value="Clear All" onClick="ClearAll()"></td>
                <td><input type="submit" value="Update Map" name="userAction"></td>
              </tr>
            </table>
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
                    <%= ts[i] %>
                    </td></tr>
                  <%}%>
                  </table>
                </td>
              </tr>
            </table>
      <%   }
         }
      %>
    </td>

  </tr>

  <!-- Error message  -->
  <tr><td colspan="3" align="left"><font color="#FF0000"><b><%= mapMessage %></b></font></td></tr>

  <!-- Identification result -->
  <% if (featureInfo !=null && featureInfo.length>0) {%>
    <tr><td colspan="3"><b>Identification result:</b></td></tr>
    <tr><td colspan="3">
    <table border="1">
      <% for (int i=0; i<featureInfo.length; i++) {%>
        <tr>
        <% String[] row = featureInfo[i];
           for (int k=0; k<row.length; k++) {%>
            <td><%= row[k] %></td>
           <% } %>
        </tr>
      <% } %>
    </table>
    </td></tr>
  <% } %>

  <!-- SQL Query window  -->
  <tr><td><b>SQL Query:</b></td></tr>
  <tr>
    <td colspan="2" align="left">
      <textarea name="sqlQuery" rows="6" cols="80" wrap ><%=sqlQuery==null?"":sqlQuery%></textarea>
    </td>
    <td>
     <table align="left">
       <tr><td align="center"><input type="submit" value="Execute Query" name="userAction"></td></tr>
       <tr><td align="center"><input type="submit" value="Clear Query" name="userAction"></td></tr>
     </table>
    </td>
  </tr>

  <tr><td><b>XML Request:</b></td></tr>
  <tr>
    <td colspan="2" align="left">
      <textarea rows="6" cols="80" wrap readonly><%=mapRequest%>
      </textarea>
    </td>
  </tr>
  <tr><td><b>XML Response:</b></td></tr>
  <tr>
    <td colspan="2" align="left">
      <textarea rows="6" cols="80" wrap readonly><%=mapResponse%></textarea>
    </td>
  </tr>

</table>

<SCRIPT language=JavaScript>
<!--
if (document.all) {
    document.all("mapImage").style.cursor = 'crosshair';
}
//-->
</SCRIPT>

</form>

</body>

</html>
