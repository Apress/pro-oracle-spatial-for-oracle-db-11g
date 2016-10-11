<!--

This JSP illustrates the use of the Java interface to Mapviewer.

The logic is identical to the SimpleViewerXML example:

It lets you enter the name of a datasource and a map defined in that
data source, and choose a center point and size for the resulting map.
Navigation buttons let you zoom and pan. Clicking on the map will
recenter it on that point.

For each action, the following steps take place:

- get the parameters of the new map request from the user input
- create a Mapviewer object and initialize it based on those parameters
- call the run() method of the object
- update the HTML page with the URL of the new map.

An additional text area (read only) shows the XML request sent to the server
(there is no method yet to see the XML response)

-->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.net.*, java.io.*, java.util.*" %>
<%@ page import="java.awt.Dimension" %>
<%@ page import="java.awt.geom.Point2D" %>
<%@ page import="oracle.lbs.mapclient.MapViewer" %>

<%

  // Name of this JSP
  String jspURL = response.encodeURL(request.getRequestURI());

  // Dynamic request parameters
  String mapViewerURL = null;         // URL of Mapviewer servlet
  String dataSource = null;           // Data source name
  String baseMap = null;              // Map name
  String mapTitle = "";               // Map title
  double cx = 0;                      // Map center X in map coordinates
  double cy = 0;                      // Map center Y in map coordinates
  double mapSize = 0;                 // Map size (height) in map coordinates
                                      // Map bounding box :
  double boxLLX = 0;                  //   Lower Left X (= Xmin)
  double boxLLY = 0;                  //   Lower Left Y (= Ymin)
  double boxURX = 0;                  //   Upper Right X (= Xmax)
  double boxURY = 0;                  //   Upper Right M (= Ymax)

  // Other variables
  int    imgCX = 0;                   // Map center X in image coordinates
  int    imgCY = 0;                   // Map center Y in image coordinates
  String imgURL = "";                 // URL of returned map
  String mapRequest = "";             // Map request (XML)
  String mapResponse = "";            // Map response (XML)
  String mapError = "";               // Error or exception
  int    mapWidth = 600;              // Map width in pixels
  int    mapHeight = 500;             // Map height in pixels
  int    inputSize = 24;              // Size of input fields

  // Mapviewer object
  MapViewer mv = null;

  // Load input parameters

  mapViewerURL = request.getParameter("mapViewerURL");
  if (mapViewerURL == null)
    mapViewerURL = "http://"+ request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/omserver";

  dataSource = request.getParameter("dataSource");
  if (dataSource == null)
    dataSource = "";

  mapTitle = request.getParameter("mapTitle");
  if (mapTitle ==null)
    mapTitle = "";

  baseMap = request.getParameter("baseMap");
  if (baseMap == null)
    baseMap = "";

  cx = request.getParameter("cx") != null ?
    Double.valueOf(request.getParameter("cx")).doubleValue() : 0.0;
  cy = request.getParameter("cy") != null ?
    Double.valueOf(request.getParameter("cy")).doubleValue() : 0.0;
  mapSize = request.getParameter("mapSize") != null ?
    Double.valueOf(request.getParameter("mapSize")).doubleValue() : 0.0;

  // Hidden variables

  boxLLX = request.getParameter("boxLLX") != null ?
    Double.valueOf(request.getParameter("boxLLX")).doubleValue():0.0;
  boxLLY = request.getParameter("boxLLY") != null ?
    Double.valueOf(request.getParameter("boxLLY")).doubleValue():0.0;
  boxURX = request.getParameter("boxURX") != null ?
    Double.valueOf(request.getParameter("boxURX")).doubleValue():0.0;
  boxURY = request.getParameter("boxURY") != null ?
    Double.valueOf(request.getParameter("boxURY")).doubleValue():0.0;

  // Handle user action from form
  String userAction = request.getParameter("action");
  if (request.getParameter("mapImage.x") != null)
    userAction = "reCenter";

  //try {

    if (userAction != null) {

      // User action detected. Can be one of the following:
      // - "Get Map"
      //   new map parameters entered
      // - Zoom/Pan:
      //   zoom or pan button clicked
      // - "reCenter"
      //   user clicked on map to recenter

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

      // User clicked on the map. Get the coordinates of the clicked point
      // convert to map coordinates, and use it as new map center
      else if (userAction.equals("reCenter")) {
        imgCX = Integer.parseInt(request.getParameter("mapImage.x"));
        imgCY = Integer.parseInt(request.getParameter("mapImage.y"));
        cx = boxLLX+(double)imgCX/mapWidth*(boxURX-boxLLX);
        cy = boxURY-(double)imgCY/mapHeight*(boxURY-boxLLY);
        Point2D center = mv.getUserPoint(imgCX,imgCY);
        //cx = center.getX();
        //cy = center.getY();
      }

      // Setup map request
      mv = new MapViewer(mapViewerURL);
      mv.setDataSourceName(dataSource);               // Data source
      mv.setBaseMapName(baseMap);                     // Base map
      mv.setMapTitle(" ");                            // No title
      mv.setImageFormat(MapViewer.FORMAT_PNG_URL);    // Map format
      mv.setDeviceSize(
      new Dimension(mapWidth, mapHeight));            // Map size
      mv.setCenterAndSize(cx, cy, mapSize);

      // Add a legend
      String[][][] legend = new String[][][]
      {
        {
          {"Map Legend",  null,               "true",  null, "false"},
          {"Counties",    "C.US MAP YELLOW",  "false", null, "false"},
          {"Rivers",      "C.RIVER",          "false", null, "false"},
          {"Parks",       "C.PARK FOREST",    "false", null, "false"}
        },
        {
          {"",            null,               "false", null, "true" },
          {"Interstates", "L.PH",             "false", null, "false"},
          {"Major Cities","M.CITY HALL 4",    "false", null, "false"}
        }
      };

      mv.setMapLegend(
        "white",       // Fill color
        "128",         // Fill opacity
        "red",         // Stroke color
        "medium",      // Legend size
        "SOUTH_EAST",  // Legenfd position
        legend         // Legend array
      );

      // Send map request
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

      // Get the MBR of the map
      double box[] = mv.getMapMBR();
      boxLLX = box[0];
      boxLLY = box[1];
      boxURX = box[2];
      boxURY = box[3];
    }
  //} catch (Exception e) {
  //   mapError = "Request failed: "+ e.toString();
  //}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Oracle Spatial Viewer (Java API)</title>
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
  document.viewerForm.boxLLX.value="0.0"
  document.viewerForm.boxLLY.value="0.0"
  document.viewerForm.boxURX.value="0.0"
  document.viewerForm.boxURY.value="0.0"
  document.viewerForm.mapRequest.value=""
  return false
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
<h1>Oracle Spatial Viewer using the Java API</h1>

<form name="viewerForm" method="post" action="<%= jspURL %>"
 onSubmit="return checkForm()">

<input type="hidden" name="boxLLX" value="<%= boxLLX %>">
<input type="hidden" name="boxLLY" value="<%= boxLLY %>">
<input type="hidden" name="boxURX" value="<%= boxURX %>">
<input type="hidden" name="boxURY" value="<%= boxURY %>">

<table border="0" cellpadding="0" cellspacing="0" >
  <tr>

    <!-- Map selection  -->
    <td valign="top">
      <table border="0">
        <tr><td><b>MapViewer URL:</b></td></tr>
        <tr><td><input type="text" name="mapViewerURL" value="<%= mapViewerURL %>" size="<%= inputSize %>"/></td></tr>
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
           <input type="button" name="clear" value="Clear" onClick="clearForm()">
           <input type="submit" name="action" value="Get Map" alt="Get new map">
          </td></tr>
        <tr><td width=120><font color="#FF0000" size="-1"><b><%= mapError %></b></font></td></tr>
      </table>
    </td>

    <td valign="top">
     <table border="0" cellpadding="0" cellspacing="0">

      <!-- Map display  -->
      <tr>
        <td valign="top" align="center" width="<%= mapWidth+20 %>" height="<%= mapHeight %>" >
          <% if (imgURL.trim().length()!=0) { %>
            <input type="image"
              border="1"
              name="mapImage"
              src="<%= imgURL %>"
              width="<%= mapWidth %>"
              height="<%= mapHeight %>"
              alt="Click to re-center">
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
              <td><input type="submit" name="action" value="Zm In">  </td>
              <td><input type="submit" name="action" value="Zm Out"> </td>
              <td><input type="submit" name="action" value="Pan W."> </td>
              <td><input type="submit" name="action" value="Pan N."> </td>
              <td><input type="submit" name="action" value="Pan S."> </td>
              <td><input type="submit" name="action" value="Pan E."> </td>
            </tr>
          </table>
        </td>
      </tr>

     </table>
    </td>
  </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" >
  <tr><td><b>XML Request:</b></td></tr>
  <tr>
    <td align="left">
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

</form>

</body>
</html>
