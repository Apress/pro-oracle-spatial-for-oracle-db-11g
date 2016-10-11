<!--

This JSP illustrates the use of the XML interface to Mapviewer.

It lets you enter the name of a datasource and a map defined in that
data source, and choose a center point and size for the resulting map.
Navigation buttons let you zoom and pan. Clicking on the map will
recenter it on that point.

For each action, the following steps take place:

- get the parameters of the new map request from the user input
- construct an XML request using those parameters
- send the XML request to the Mapviewer server via HTTP
- parse the XML response received (map URL and bounds)
- update the HTML page with the URL of new map.

Two text areas show the XML request sent to the server as
sell as the response returned by the server.

You can also experiment by modifying directly the XML request and sending
it to the MapViewer server using the "Send XML" button. The XML response box
will show any error. If the XML request is valid, then a new map will be
displayed.

Note that the example assumes that you do not change the datasource or basemap
parameters in the XML request.

-->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.net.*, java.io.*, java.util.*" %>
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
  String mapRequest = "";             // Map request (XML)

  // Other variables
  int    imgCX = 0;                   // Map center X in image coordinates
  int    imgCY = 0;                   // Map center Y in image coordinates
  String imgURL = "";                 // URL of returned map
  String mapResponse = "";            // Map response (XML)
  String mapError = "";               // Error or exception
  int    mapWidth = 480;              // Map width in pixels
  int    mapHeight = 400;             // Map height in pixels
  int    inputSize = 24;              // Size of input fields

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

  mapRequest = request.getParameter("mapRequest");
  if (mapRequest == null)
    mapRequest = "";

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

  if (userAction != null) {

    // User action detected. Can be one of the following:
    // - "Get Map"
    //   new map parameters entered
    // - Zoom/Pan:
    //   zoom or pan button clicked
    // - "reCenter"
    //   user clicked on map to recenter
    // - "send XML"
    //   manually entered XML request

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
    }

    // Construct the XML map request
    if (!userAction.equals("Send XML"))
      mapRequest =
        "<?xml version=\"1.0\" standalone=\"yes\" ?>\n"   +
        "<map_request \n"                                 +
        "  title=\""      + mapTitle      + "\"\n"       +
        (baseMap.trim().length()!=0 ?
         ("  basemap=\""    + baseMap    + "\"\n") : "")  +
        "   datasource=\"" + dataSource + "\"\n"          +
        "   width=\""      + mapWidth      + "\"\n"       +
        "   height=\""     + mapHeight     + "\"\n"       +
        "   format=\"PNG_URL\" >\n"                       +
        "  <center size=\"" + mapSize + "\">\n"              +
        "    <geoFeature>\n"                              +
        "      <geometricProperty typeName=\"center\">\n" +
        "        <Point>\n"                               +
        "          <coordinates>\n"                       +
        "            " + cx + ", " + cy + "\n"            +
        "          </coordinates>\n"                      +
        "        </Point>\n"                              +
        "      </geometricProperty>\n"                    +
        "    </geoFeature>\n"                             +
        "  </center>\n"                                   +
        "</map_request>\n";

    // Send request to server and process the response
    // If a SUCCESS map response is received,
    // extract the image URL from map content and re-compute the center of the map
    // from the box coordinates. Record the response to display in the text area.

    OutputStream os = null;             // Output stream to servlet
    InputStream is = null;              // Input stream from servet
    try {

      // Get a connection to the Mapviewer server
      URL url = null;                   // URL to Mapviewer servlet
      HttpURLConnection hurlc = null;   // HTTP connection
      url = new URL(mapViewerURL);
      hurlc = (HttpURLConnection) url.openConnection();
      hurlc.setDoOutput(true);
      hurlc.setDoInput(true);
      hurlc.setUseCaches(false);
      hurlc.setRequestMethod("POST");

      // Send the map request to the Mapviewer server
      os = hurlc.getOutputStream();
      os.write(("xml_request=" + mapRequest).getBytes());
      os.flush();
      os.close();

      // Get the XML response from the Mapviewer server
      StringBuffer sb = new StringBuffer();
      int c;
      is = hurlc.getInputStream();
      while ((c = is.read()) != -1)
        sb.append((char) (byte) c);
      is.close();
      mapResponse = sb.toString();

      // Following variables used to parse XML response
      String errorCodeSucc = "error_code=\"SUCCESS\"";
      String urlStart = "url=\"";
      String urlEnd = "\" />";
      int urlStartIdx = -1;
      int urlEndIdx = -1;
      String coordStart = "<coordinates>";
      String coordEnd = "</coordinates>";
      int coordStartIdx = -1;
      int coordEndIdx = -1;
      String box = null;
      StringTokenizer st = null;

      // check for SUCCESS and extract mapContent URL
      if (mapResponse.indexOf(errorCodeSucc) == -1) {
        mapError = "Request failed - see XML reponse for details";
      } else if ((urlStartIdx=mapResponse.indexOf(urlStart))==-1) {
        mapError = "Error extracting map URL from XML response";
      } else {
        urlStartIdx += urlStart.length();
        if ((urlEndIdx=mapResponse.indexOf(urlEnd,urlStartIdx))==-1)
          mapError = "Error extracting map URL from XML response";
        else
          imgURL = new String(mapResponse.substring(urlStartIdx, urlEndIdx));
          if ((coordStartIdx=mapResponse.indexOf(coordStart))!=-1) {
            coordStartIdx += coordStart.length();
            if ((coordEndIdx=mapResponse.indexOf(coordEnd,coordStartIdx))!=-1) {
              box = mapResponse.substring(coordStartIdx, coordEndIdx);
              st = new StringTokenizer(box,", \n\t\r\f");
              try {
                boxLLX = Double.valueOf(st.nextToken()).doubleValue();
                boxLLY = Double.valueOf(st.nextToken()).doubleValue();
                boxURX = Double.valueOf(st.nextToken()).doubleValue();
                boxURY = Double.valueOf(st.nextToken()).doubleValue();
                cx = (boxLLX+boxURX)/2;
                cy = (boxLLY+boxURY)/2;
                mapSize = boxURY - boxLLY;
              } catch(Exception e) {
                //ignore it
              }
            }
          } else {
            mapError = "Error extracting map bounds from XML response";
          }

      }
    } catch (Exception e) {
        mapError = "Exception: "+ e.toString();
    }

    try {
      if (os != null)
        os.close();
      if (is != null)
        is.close();
    } catch (Exception ee) {
        mapError = "Exception: "+ ee.toString();
    }

    mapResponse = mapResponse + mapError;
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Oracle Spatial Viewer (XML API)</title>
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
  document.viewerForm.mapResponse.value=""
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
<h1>Oracle Spatial Viewer using the XML API</h1>

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
  <tr><td><b>XML Request:</b></td></tr>
  <tr>
    <td colspan="2" align="left">
      <table><tr>
      <td>
       <textarea name="mapRequest" rows="6" cols="65" wrap><%=mapRequest%></textarea>
      </td>
      <td valign="top"><input type="submit" name="action" value="Send XML"></td>
      </tr></table>
    </td>
  </tr>
  <tr><td><b>XML Response:</b></td></tr>
  <tr>
    <td colspan="2" align="left">
      <textarea rows="6" cols="65" wrap readonly><%=mapResponse%></textarea>
    </td>
  </tr>
</table>

</form>

</body>
</html>
