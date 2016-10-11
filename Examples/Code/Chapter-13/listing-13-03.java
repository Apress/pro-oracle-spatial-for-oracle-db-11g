// Listing 13-3. Zooming and Panning

if (userAction.equals("Get Map")) {

  // User clicked the 'Get Map' button and
  // chose a new datasource or map name,
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
  imgCX = Integer.valueOf(request.getParameter("mapImage.x")).intValue();
  imgCY = Integer.valueOf(request.getParameter("mapImage.y")).intValue();
  cx = boxLLX+imgCX/mapWidth*(boxURX-boxLLX);
  cy = boxURY-imgCY/mapHeight*(boxURY-boxLLY);
}
