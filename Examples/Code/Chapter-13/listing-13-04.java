// Listing 13-4. Using the zoom() and pan()Methods

// Fetch saved MapViewer object from session (if any)
MapViewer mv = (MapViewer) session.getAttribute("mvhandle");
if (mv==null) {
  // No MapViewer object found - must create and initialize it
  mv = new MapViewer(MapViewerURL);
  session.setAttribute("mvhandle", mv);     // keep client handle in the session
}

if (userAction.equals("Get Map")) {
  // User clicked the 'Get Map' button and
  // choose a new datasource or map name,
  // or manually entered a new map center and size
  // Initialize the MapViewer object with the entered
  // information
  mv.setDataSourceName(dataSource);                       // Data source
  mv.setBaseMapName(baseMap);                             // Base map
  mv.setMapTitle(" ");                                    // No title
  mv.setImageFormat(MapViewer.FORMAT_PNG_URL);            // Map format
  mv.setDeviceSize(new Dimension(mapWidth, mapHeight));   // Map size
  mv.setCenterAndSize(cx, cy, mapSize);
  // Send map request
  mv.run();
}

// User clicked one of the 'Zoom' buttons:
// Zoom in or out by a fixed factor (2x)
else if (userAction.equals("Zm In"))
  mv.zoomIn(2);
else if (userAction.equals("Zm Out"))
  mv.zoomOut(2);

// User clicked one of the 'Pan' buttons:
// shift map 50% in the desired direction.
else if (userAction.equals("Pan W."))
  mv.pan (0, mapHeight/2);
else if (userAction.equals("Pan N."))
  mv.pan (mapWidth/2, 0);
else if (userAction.equals("Pan S."))
  mv.pan (mapWidth/2, mapHeight);
else if (userAction.equals("Pan E."))
  mv.pan (mapWidth, mapHeight/2);

// User clicked on the map. Get the coordinates of the clicked point
// convert to map coordinates, and use it as new map center
else if (userAction.equals("reCenter")) {
  imgCX = Integer.valueOf(request.getParameter("mapImage.x")).intValue();
  imgCY = Integer.valueOf(request.getParameter("mapImage.y")).intValue();
  mv.pan (imgCX, imgCY);
}
