<!--

This JSP illustrates the use of the JSP tags interface to Mapviewer.

The parameters for the map to display (data source, base map name,
initial center and size) are hard coded.

You interact with the map using mouse clicks. A radio button defines
the kind of interaction that takes place when you click:

- recenter
- recenter and zoom-in
- recenter and zoom-out
- identify

The "identify" action uses the "identify" tag to locate the county
(table US_COUNTIES) at the point clicked.

-->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/mvtaglib.tld" prefix="mv" %>
<%@ page session="true" %>
<%@ page import="oracle.lbs.mapclient.MapViewer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Oracle Spatial Viewer using JSP tags</title>
  <link rel="stylesheet" href="my.css" type="text/css">
</head>
<body>

<%
  // Name of this JSP
  String jspURL = response.encodeURL(request.getRequestURI());
  // URL of Mapviewer servlet
  String mapViewerURL =
    "http://"+ request.getServerName()+":"+request.getServerPort()+
    request.getContextPath()+"/omserver";

  String[][] featureInfo = null;
  if( request.getParameter("session-initialized") == null ||
      request.getParameter("new-session") == "true") {

%>
    <!-- Initialize MapViewer handle.and save it in the session -->
    <mv:init
      url="<%=mapViewerURL%>"
      datasource="spatial"
      id="mvHandleSimpleViewerTags" />

    <!-- Set map format and size -->
    <mv:setParam
      title="Example map using JSP tags"
      width="480"
      height="360"/>

    <!-- Add themes from the base map -->
    <mv:importBaseMap name="us_base_map"/>

    <!-- Additional themes -->
    <mv:addPredefinedTheme name="parks.us_parks"/>

    <!--  Set initial map center and size -->
    <mv:setParam
      centerX="-122.0"
      centerY="37.8"
      size="1.5" />

<%
  }

  MapViewer mvHandle = (MapViewer) session.getAttribute("mvHandleSimpleViewerTags");

  String userAction = request.getParameter("userAction");
  String imgCX = request.getParameter("userClick.x");
  String imgCY = request.getParameter("userClick.y");

  if("identify".equals(userAction)) {

%>
    <mv:identify
      id="identifyResults"
      style="M.CYAN PIN"
      table="us_counties"
      spatial_column="geom"
      srid="8307"
      x="<%= imgCX %>" y="<%= imgCY %>" >
      county, state_abrv state, totpop, landsqmi, poppsqmi
    </mv:identify>
<%
    featureInfo = identifyResults;
  }
  else {
%>
    <mv:run
      action="<%=userAction%>"
      x="<%= imgCX %>"
      y="<%= imgCY %>" />
<%
  }
%>


<!-- Output the HTML content -->
<h1>Oracle Spatial Viewer using JSP tags</h1>

<form name="viewerForm" method="post" action="<%= jspURL %>" >

<table border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td valign="top">
     <table border="0" cellpadding="0" cellspacing="0">

      <!-- Map display  -->
      <tr>
        <td valign="top" align="center" >
        <input type="image"
           border="1"
           src="<mv:getMapURL />"
           name="userClick"
           alt="Click on the map for selected action"
        >
        </td>
      </tr>

      <!-- Map click action  -->
      <tr>
        <td align="center">
          <input type="radio" name="userAction" value="recenter"
            <%= "recenter".equals(userAction)?"checked":""%> ><B>Re-center</B>
          <input type="radio" name="userAction" value="zoomin"
            <%= "zoomin".equals(userAction)?"checked":""%> ><B>Zoom In</B>
          <input type="radio" name="userAction" value="zoomout"
            <%= "zoomout".equals(userAction)?"checked":""%> ><B>Zoom Out</B>
          <input type="radio" name="userAction" value="identify"
            <%= "identify".equals(userAction)?"checked":""%> ><B>Identify</B>
        </td>
      </tr>
     </table>
    </td>
  </tr>

  <!-- Current position -->
  <tr>
    <td align="center">
      <i>Center</i>[<b><%=mvHandle.getRequestCenter().getX()+","+
        mvHandle.getRequestCenter().getY()%></b>]&nbsp;&nbsp;
      <i>Scale</i>[<b><%=mvHandle.getMapScale()%></b>]
    </td>
  </tr>

  <!-- Identification result -->
  <% if (featureInfo !=null && featureInfo.length>0) {%>
    <tr><td align="center">
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


</table>

<input type="hidden" name="session-initialized" value="true" >

</form>

</body>
</html>
