// --------------------------------------------------------------------------------
// Configuration constants
// --------------------------------------------------------------------------------

// Customize the following to fit your environment
var baseURL                 = "http://"+document.location.host+"/mapviewer";
var datasourceName          = "SPATIAL";
var baseMapName             = "US_CITY_MAP";
var mapSRID                 = 8307;

// Zoom levels for theme visibility
var minVisibleZoomLevel     = 13;
var maxWholeImageLevel      = 15;
var minClickableZoomLevel   = 16;

// Set defaults for the "auto refresh" option
var autoRefresh             = true;

// This is the difference between the overview map and the main map.
// For example, when the main map is zoomed in at zoom level 16, then the overview map is at zoom level 10.
var overviewZoom            = 6;

// Fixed locations
// Each entry of the array contains the following:
// - name of the location,
// - X and Y coordinates of the location (the map will be centered on that point)
// - zoom level of the map
// The loadMainMap() procedure takes the index of a location as input
var locations = new Array (
  new Array ("San Francisco, CA", -122.43302833333328, 37.7878425, 16),
  new Array ("Washington, DC",    -77.016167,          38.90505,   16)
)

// List of FOI themes to show on top of the map
var foiThemes = new Array(
  "BRANCHES",
  "CUSTOMERS",
  "COMPETITORS"
);

// Labels for FOI themes.
var foiThemeLabels = new Array(
   "Branches",
   "Customers",
   "Competitors"
);

// --------------------------------------------------------------------------------
// Global variables
// --------------------------------------------------------------------------------

// The main mapview object
var mapview = null;

// Dynamic search themes
var searchTheme = null;
var searchBufferTheme = null;

// Dynamic address marker
var gcMarker = null;

// Details of current address marker
var gc_longitude;
var gc_latitude;
var gc_house_number;
var gc_street;
var gc_builtup_area;
var gc_state;
var gc_postal_code;

// FOI currently selected in the information window
var currentFOI = null;

// What are we showing in the INFO Panel ?
var showSearchResults = false;

// --------------------------------------------------------------------------------
// loadMainMap()
//
// This is the main entry point of the application. All other functions are
// either called from here, or are called from events (mouse click, scale change, etc)
// --------------------------------------------------------------------------------

function loadMainMap(location)
{
  // Define initial map center and scale based on chosen location
  mapCenterX = locations[location][1];
  mapCenterY = locations[location][2];
  mapZoom =    locations[location][3];

  // Create an MVMapView instance to display the map
  mapview = new MVMapView(document.getElementById("PANEL_MAP"), baseURL);

  // Add a base map layer as background.
  var basemap = new MVBaseMap(datasourceName+"."+baseMapName);
  mapview.addBaseMapLayer(basemap);

  // Set the initial map center and zoom level
  var center=MVSdoGeometry.createPoint(mapCenterX, mapCenterY, mapSRID);
  mapview.setCenter(center);
  mapview.setZoomLevel(mapZoom);

  // Add a navigation panel on the right side of the map
  mapview.setHomeMap(center, mapZoom);
  mapview.addNavigationPanel("EAST");

 // Add a scale bar
  mapview.addScaleBar();

  // Add a copyright notice
  mapview.addCopyRightNote("Powered by Oracle Maps");

  // Add a marquee zoom control
  var toolBar =
  '<div style="background-color:white; border:1px solid black;">'+
  '&nbsp;Marquee Zoom:&nbsp;'+
  '<input id="marqueezoom" type="checkbox" value="marqueezoom" onclick="toggleMarqueeZoom(this)" unchecked/>'+
  '</div>'
  md = new MVMapDecoration(toolBar, 0, 0) ;
  mapview.addMapDecoration(md);

  // Setup an overview map as a collapsible decoration and add it to the map
  ovcontainer = new MVMapDecoration(null,null,null,160,120) ;
  ovcontainer.setCollapsible(true);
  mapview.addMapDecoration(ovcontainer);
  var over=new MVOverviewMap(ovcontainer.getContainerDiv(),overviewZoom);
  mapview.addOverviewMap(over)

  // Setup FOI layers and add to map
  for (i in foiThemes) {
    theme = new MVThemeBasedFOI(foiThemes[i],datasourceName+"."+foiThemes[i]);
    theme.setMinVisibleZoomLevel(minVisibleZoomLevel);
    theme.setMaxWholeImageLevel(maxWholeImageLevel);
    theme.setMinClickableZoomLevel(minClickableZoomLevel);
    theme.setAutoRefresh(autoRefresh);       // Enable or disable auto refresh
    theme.enableInfoWindow(false);           // Will use our own info window via an event listener
    theme.setQueryWindowMultiplier(1);       // Only load FOIs in current map window
    theme.enableImageCaching(true);          // Cache FOI images (they won't change)
    theme.addEventListener('mouse_click', foiMouseClickEvent) ;
    theme.addEventListener('after_refresh',foiAfterRefreshEvent);
    theme.setVisible(false);
    mapview.addThemeBasedFOI(theme);
  }

  // Setup event listeners
  mapview.addEventListener("recenter", mapRecenterEvent);
  mapview.addEventListener("zoom_level_change", mapZoomLevelChangeEvent);

  // Setup control panel
  setupControlPanel()
  document.getElementById("PANEL_SEARCH_CONTROL").style.visibility="hidden";
  document.getElementById("PANEL_INFO").style.visibility="hidden";

  // Display the map
  mapview.display();
}

// --------------------------------------------------------------------------------
// setupControlPanel()
// This sets up the select list of FOI themes as well as the direct links
// to the hard-coded locations
// --------------------------------------------------------------------------------
function setupControlPanel()
{
  // Setup the list of selectable themes
  html = '';
  for (i in foiThemes) {
    html += '<dt>' +
      '<input type="checkbox" id="checkedTheme" name="checkedTheme" value="' + foiThemes[i] + '" onClick="toggleTheme(this)" unchecked />' +
      '<img src=' + baseURL + '/omserver?sty=m.' + foiThemes[i] + '&ds=' + datasourceName +'&f=png&w=12&h=12&aa=true" >' +
      foiThemeLabels[i];
  }
  document.getElementById("THEMES_LIST").innerHTML=html;

  // Setup the list of direct location links
  html = '';
  for (i in locations) {
    html += '<dt>' +
      '<a href="javascript:loadMainMap('+i+')">'+locations[i][0]+'</a>';
  }
  document.getElementById("DIRECT_LINKS").innerHTML=html;

  // Initial settings for autoRefresh toggle
  document.controlPanel.autoRefresh.checked = autoRefresh;
}

// --------------------------------------------------------------------------------
// Event handlers
//
// Those events control the refreshing of the list of FOIs displayed iside the
// information panel so that the list matches exactly the FOIs displayed on the map
// --------------------------------------------------------------------------------
function mapRecenterEvent ()
{
  refreshInfoPanel()
}
function mapZoomLevelChangeEvent (oldZoomLevel, newZoomLevel)
{
  refreshInfoPanel()
}
function foiMouseClickEvent (loc, foi)
{
  currentFOI = foi;
  displayInfoWindow()
}

function foiAfterRefreshEvent()
{
  refreshInfoPanel()
}

// --------------------------------------------------------------------------------
// toggleMarqueeZoom()
// Turns marquee zoom mode on or off
// --------------------------------------------------------------------------------

function toggleMarqueeZoom(checkBox)
{
  if(checkBox.checked)
    mapview.startMarqueeZoom("continuous");
  else
    mapview.stopMarqueeZoom() ;
}

// --------------------------------------------------------------------------------
// toggleTheme()
// Processes the click on the select box for a FOI theme.
// i.e. toggles the visibility of a theme
// --------------------------------------------------------------------------------
function toggleTheme(checkBox)
{
  theme = mapview.getThemeBasedFOI (checkBox.value);
  if(checkBox.checked)
    theme.setVisible(true);
  else
    theme.setVisible(false);
  refreshInfoPanel();
}

// --------------------------------------------------------------------------------
// toggleAllThemes()
// Turns all FOI themes visible or invisible
// --------------------------------------------------------------------------------
function toggleAllThemes(visible)
{
  for (var i in foiThemes) {
    document.controlPanel.checkedTheme[i].checked = visible;
    toggleTheme(document.controlPanel.checkedTheme[i]);
  }
}

// --------------------------------------------------------------------------------
// toggleAutoRefresh(checkBox)
// --------------------------------------------------------------------------------
function toggleAutoRefresh(checkBox)
{
  autoRefresh = checkBox.checked;
  for (var i in foiThemes) {
    var theme = mapview.getThemeBasedFOI(foiThemes[i]);
    theme.setAutoRefresh(autoRefresh);
  }
}

// --------------------------------------------------------------------------------
// refreshAllThemes()
// Refreshes all visible FOI themes
// --------------------------------------------------------------------------------
function refreshAllThemes()
{
  for (var i in foiThemes) {
    var themeVisible = document.controlPanel.checkedTheme[i].checked;
    if (themeVisible) {
      var theme = mapview.getThemeBasedFOI(foiThemes[i]);
      theme.refresh();
    }
  }
  refreshInfoPanel();
}

// --------------------------------------------------------------------------------
// refreshInfoPanel()
// Updates the list of FOIs currently displayed in the info panel
// --------------------------------------------------------------------------------
function refreshInfoPanel()
{
  clearInfoPanel();
  if (showSearchResults)
    showSelectedFOIs();
  else
    showAllVisibleFOIs();
  refreshStatus();
}

// --------------------------------------------------------------------------------
// displayInfoWindow()
// Displays the information window when a FOI object is clicked.
// --------------------------------------------------------------------------------
function displayInfoWindow()
{
  foi = currentFOI
  var html = '';
  html += '<b>Id: </b>'+foi.attrs[0]+'<br>';
  html += '<b>Phone: </b>'+foi.attrs[2]+'<br>';
  html += '<p><a href="javascript:showFOIDetails()">More Info<a>';
  html += '&nbsp;&nbsp;<a href="javascript:displaySearchWindow()">Search Around<a>';
  width = 250;
  height = 120;
  loc = MVSdoGeometry.createPoint(foi.x,foi.y);
  mapview.displayInfoWindow(loc, html, width, height, "MVInfoWindowStyle1", "&nbsp;&nbsp;"+foi.name+"&nbsp;&nbsp;");
}

// --------------------------------------------------------------------------------
// displaySearchWindow()
// Redisplays the information window with search selection information
// --------------------------------------------------------------------------------
function displaySearchWindow()
{
  foi = currentFOI;
  var html = '';
  html += '<b>Id: </b>'+foi.attrs[0]+'<br>';
  html += '<b>Phone: </b>'+foi.attrs[2]+'<br>';
  html += '<dl>';
  for (i in foiThemes) {
    html += '<dt>' +
      '<input type="radio" name="searchThemes" value="' + foiThemes[i] + '"/>' +
      foiThemeLabels[i];
  }
  html += '</dl>';
  html += '<b>Radius: </b><input id="searchRadiusInput" size=2 value=500> meters';
  html += '&nbsp;&nbsp;<input type=button onclick="searchAround();" value="Search">'
  html += '<p><a href="javascript:displayInfoWindow()">Back<a>';
  width = 250;
  height = 120;
  loc = MVSdoGeometry.createPoint(foi.x,foi.y);
  mapview.displayInfoWindow(loc, html, width, height, "MVInfoWindowStyle1", "&nbsp;&nbsp;"+foi.name+"&nbsp;&nbsp;");
}

// --------------------------------------------------------------------------------
// searchAround()
// Selects all features around the currently selected FOI
// --------------------------------------------------------------------------------
function searchAround()
{
  // Get the currently selected FOI
  var foi = currentFOI;

  // Get the value of the chosen radius
  var searchRadius = document.getElementById('searchRadiusInput').value;

  // Get the name of the theme to search
  var searchThemes = document.getElementsByName('searchThemes');
  var searchThemeName = null;
  for (var i=0; i<searchThemes.length; i++) {
    if (searchThemes[i].checked)
      searchThemeName = searchThemes[i].value;
  }
  if (!searchThemeName) {
    alert ("Please select the theme to search");
    return;
  }

  // Build the parameters for the search
  var loc = MVSdoGeometry.createPoint(foi.x,foi.y,mapSRID);
  var distanceString = 'distance='+searchRadius+' unit=m';

  // Add the search window theme to the map view
  if (searchBufferTheme)
    mapview.removeThemeBasedFOI(searchBufferTheme);
  searchBufferTheme = new MVThemeBasedFOI('buffer', 'DYNAMIC_CIRCULAR_BUFFER');
  searchBufferTheme.setQueryParameters(loc, searchRadius) ;
  searchBufferTheme.setBoundingTheme(true);
  searchBufferTheme.setClickable(false);
  searchBufferTheme. enableImageCaching(true);
  searchBufferTheme.setAutoRefresh(false);
  mapview.addThemeBasedFOI(searchBufferTheme);

  // Add the search theme to the map view. Remove it first if already shown
  if (searchTheme)
    mapview.removeThemeBasedFOI(searchTheme);
  searchTheme = new MVThemeBasedFOI('search', searchThemeName+'_WD');
  searchTheme.setQueryParameters(loc, distanceString) ;
  searchTheme.setRenderingStyle("M.CYAN PIN");
  searchTheme.enableImageCaching(true);
  searchTheme.setAutoRefresh(false);
  searchTheme.addEventListener('mouse_click', foiMouseClickEvent);
  searchTheme.addEventListener('after_refresh', foiAfterRefreshEvent);
  mapview.addThemeBasedFOI(searchTheme);

  // Make controls appear
  document.getElementById("PANEL_SEARCH_CONTROL").style.visibility="visible";
  showSearchResults = true;

}

// --------------------------------------------------------------------------------
// showSearch()
// Switches the content of the info panel between query results and all FOIs
// Also makes query results and query buffer visible on map
// --------------------------------------------------------------------------------
function showSearch(show)
{
  showSearchResults = show;
  searchTheme.setVisible(show);
  searchBufferTheme.setVisible(show);
  refreshInfoPanel();
}

// --------------------------------------------------------------------------------
// clearSearch()
// Clears the query results
// --------------------------------------------------------------------------------
function clearSearch()
{
  // No longer showing results
  showSearchResults = false;
  // Remove control bar
  document.getElementById("PANEL_SEARCH_CONTROL").style.visibility="hidden";
  // Remove search theme and buffer from mapview
  mapview.removeThemeBasedFOI(searchBufferTheme);
  mapview.removeThemeBasedFOI(searchTheme);
  // Refresh FOI list
  refreshInfoPanel();
}


// --------------------------------------------------------------------------------
// locateFOI (themeName, foiId)
// Find the FOI identified by its theme name and unique id
// then display its info window
// --------------------------------------------------------------------------------
function locateFOI (themeName, foiId)
{
  var foi = extractFOI (themeName, foiId)
  if (foi) {
    currentFOI = foi;
    displayInfoWindow();
  }
}

// --------------------------------------------------------------------------------
// extractFOI ((themeName, foiId)
// This function finds the data of a FOI object using its unique ID
// --------------------------------------------------------------------------------
function extractFOI (themeName, foiId)
{
  theme = mapview.getThemeBasedFOI(themeName);
  if (!theme)
    return;
  foiData = theme.getFOIData();
  if (!foiData)
    return;
  var i = 0;
  var found = false;
  for (var i=0; i<foiData.length; i++) {
    if (foiData[i].id == foiId) {
      found = true;
      break;
    }
  }
  if (found)
    return foiData[i];
  else
    return null;
}

// --------------------------------------------------------------------------------
// showFOIDetails()
// Shows details about one selected FOI in the INFO panel
// --------------------------------------------------------------------------------
function showFOIDetails()
{
  foi = currentFOI;
  var html = '<h2>'+foi.name+'</h2>';
  for (var i=0; i<foi.attrs.length; i++)
    html += '<b>'+foi.attrnames[i]+'</b>:&nbsp;'+foi.attrs[i]+'<br>';
  document.getElementById("PANEL_INFO").innerHTML=html;
}

// --------------------------------------------------------------------------------
// showAllVisibleFOIs()
// List all currently visible FOIs in the right panel (PANEL_INFO)
// Do this only if FOIs are clickable, i.e. if the current zoom level is >= minClickableZoomLevel
// --------------------------------------------------------------------------------
function showAllVisibleFOIs()
{
  if (mapview.getZoomLevel() < minClickableZoomLevel)
    return;
  var html = '';
  for (var i in foiThemes) {
    theme = mapview.getThemeBasedFOI(foiThemes[i]);
    if (theme.isVisible())
      html += displayFOIList(theme, foiThemes[i]);
  }
  document.getElementById("PANEL_INFO").innerHTML=html;
  if (html)
    document.getElementById("PANEL_INFO").style.visibility="visible";
  else
    document.getElementById("PANEL_INFO").style.visibility="hidden";
}

// --------------------------------------------------------------------------------
// showSelectedFOIs()
// List the FOIs returned by the search
// --------------------------------------------------------------------------------
function showSelectedFOIs()
{
  if (searchTheme) {
    var themeName = searchTheme.getThemeName();
    themeName = themeName.substr(0,themeName.length-3);
    var html = displayFOIList(searchTheme, themeName);
    document.getElementById("PANEL_INFO").innerHTML=html;
  }
}

// --------------------------------------------------------------------------------
// displayFOIList()
// Display a list of FOIs
// --------------------------------------------------------------------------------
function displayFOIList(theme, themeName)
{
  // Extract the FOIs in this theme
  var fois = theme.getFOIData();

  // Nothing to display if list is empty
  if (!fois)
    return '';
  var html = '<table>';
  html += '<tr><td colspan="3"><b>'+themeName+'</b></td></tr>';
  for (var i in fois) {
    // Build URL to display function
    var href = 'javascript:locateFOI("' + themeName + '","' + fois[i].id + '")';
    html += '<tr>';
    // Marker symbol
    html += '<td>' +
      '<a href=' + href + '>' +
      '<img src=' + baseURL + '/omserver?sty=m.' + themeName + '&ds=' + datasourceName +'&f=png&w=12&h=12&aa=true" border="0">' +
      '</a></td>';
    // FOI ID
    html += '<td>' +
       '<a href=' + href + '>' + fois[i].attrs[0] + '</a></td>';
    // FOI Name and telephone
    html += '<td>' +
      '<td>'+ fois[i].attrs[1] + '&nbsp;('+fois[i].attrs[2] +')</td>'
    html += '</tr>';
  }
  html += '</table><br>';
  return html;
}

// --------------------------------------------------------------------------------
// clearInfoPanel()
// Blanks out the info panel
// --------------------------------------------------------------------------------
function clearInfoPanel()
{
  clearNode(document.getElementById("PANEL_INFO"));
}

// --------------------------------------------------------------------------------
// refreshStatus()
// Updates the status panel (PANEL_STATUS) with the coordinates of the center of
// the current map, the current zoom level, and the count of FOIs
// --------------------------------------------------------------------------------
function refreshStatus()
{
var minVisibleZoomLevel     = 13;
var maxWholeImageLevel      = 14;
var minClickableZoomLevel   = 16;

  var mapCenter = mapview.getCenter();
  var x = mapCenter.getPointX().toString().substr(0,10);
  var y = mapCenter.getPointY().toString().substr(0,10);
  var zoom = mapview.getZoomLevel();
  var foiVisibility;
  if (zoom < minVisibleZoomLevel)
    foiVisibility = 'Invisible';
  else if (zoom <= maxWholeImageLevel)
    foiVisibility = 'Whole Image';
  else if (zoom < minClickableZoomLevel)
    foiVisibility = 'Not Clickable';
  else
    foiVisibility = 'Clickable';
  document.getElementById("PANEL_STATUS").innerHTML =
    "<b>Center: </b>" + x + " " + y + "&nbsp;&nbsp;&nbsp;&nbsp;" +
    "<b>Zoom Level: </b>" + zoom + "&nbsp;&nbsp;&nbsp;&nbsp;" +
    "<b>FOI Visibility: </b>" + foiVisibility;
}

// --------------------------------------------------------------------------------
// geocodeAddress()
// --------------------------------------------------------------------------------
function geocodeAddress()
{
  // Get input address and split it into lines
  var address = document.getElementById("address").value;
  var addressLines = address.split(',');

  // Construct the XML request to the Geocoder
  gcXML = '<geocode_request>'
  gcXML += ' <address_list>'
  gcXML += '  <input_location id="1" >'
  gcXML += '   <input_address>'
  gcXML += '    <unformatted country="US" >'
  for (var i in addressLines)
    gcXML += '     <address_line value="'+addressLines[i]+'" />';
  gcXML += '    </unformatted >'
  gcXML += '   </input_address>'
  gcXML += '  </input_location>'
  gcXML += ' </address_list>'
  gcXML += '</geocode_request>'

  var serverURL = "http://"+document.location.host+"/"+"geocoder/gcserver";
  var queryString = encodeURI("xml_request="+gcXML);

  // Call the geocoder via an asynchronous XMLHTTPRequest call
  var response = callServer(serverURL, queryString, geocodeAddressComplete);
}

// --------------------------------------------------------------------------------
// geocodeAddressComplete()
// This function gets called when the anynchronous XMLHTTPRequest call completes
// --------------------------------------------------------------------------------
function geocodeAddressComplete(response)
{

  // The Geocode XML response looks like this:
  /*
  <geocode_response>
    <geocode id="1" match_count="1">
      <match sequence="0" longitude="-122.4135615" latitude="37.7932878"
        match_code="1"
        error_message="????#ENUT?B281CP?"
        match_vector="????0101010??000?">
        <output_address name="" house_number="1250" street="CLAY ST" builtup_area="SAN FRANCISCO"
          order1_area="CA" order8_area="" country="US" postal_code="94108" postal_addon_code=""
          side="L" percent="0.49" edge_id="23600695" />
      </match>
    </geocode>
  </geocode_response>
  */

  // Extract the results from the XML response returned by the server
  var geocode = response.getElementsByTagName('geocode');
  var match = geocode[0].getElementsByTagName('match');
  var output_address = match[0].getElementsByTagName('output_address');

  gc_longitude    = match[0].getAttribute('longitude');
  gc_latitude     = match[0].getAttribute('latitude');
  gc_house_number = output_address[0].getAttribute('house_number');
  gc_street       = output_address[0].getAttribute('street');
  gc_builtup_area = output_address[0].getAttribute('builtup_area');
  gc_state        = output_address[0].getAttribute('order1_area');
  gc_postal_code  = output_address[0].getAttribute('postal_code');

  if (gc_longitude == 0) {
    alert ("Address not found");
    return;
  }

  // Delete existing marker, if any
  if (gcMarker)
    mapview.removeFOI (gcMarker);
  // Add a marker on the map
  var gc_loc = MVSdoGeometry.createPoint(gc_longitude, gc_latitude, mapSRID);
  gcMarker = new MVFOI("ADDRESS LOCATION", gc_loc, "SPATIAL.M.YELLOW PIN");
  gcMarker.setWidth(30);
  gcMarker.setHeight(50);
  mapview.addFOI(gcMarker);

  // Build  an info window and add it to the marker
  var html = '';
  html += gc_house_number + " " + gc_street + "<br>";
  html += gc_builtup_area + " " + gc_state + " " + gc_postal_code +"<br>";
  html += '<p><a href="javascript:displayMarkerSearchWindow()">Search Around<a>';
  html += '&nbsp;&nbsp;<a href="javascript:removeMarker()">Clear<a>';
  width = 250;
  height = 120;
  gcMarker.setInfoWindow (html, width, height);

  // Show the info window
  mapview.displayInfoWindow(gc_loc, html, width, height, "MVInfoWindowStyle1");

  // Center the map on the marker
  mapview.setCenter(gc_loc) ;

  // Save the marker
  currentFOI = gcMarker;
}

// --------------------------------------------------------------------------------
// removeMarker()
// Removes the address marker
// --------------------------------------------------------------------------------
function removeMarker()
{
  mapview.removeFOI (gcMarker);
  mapview.removeInfoWindow()
}

// --------------------------------------------------------------------------------
// displayMarkerSearchWindow()
// Redisplays the information window with search selection information
// --------------------------------------------------------------------------------
function displayMarkerSearchWindow()
{
  var foi = currentFOI;
  var html = '';
  html += gc_house_number + " " + gc_street + "<br>";
  html += gc_builtup_area + " " + gc_state + " " + gc_postal_code +"<br>";
  html += '<dl>';
  for (i in foiThemes) {
    html += '<dt>' +
      '<input type="radio" name="searchThemes" value="' + foiThemes[i] + '"/>' +
      foiThemeLabels[i];
  }
  html += '</dl>';
  html += '<b>Radius: </b><input id="searchRadiusInput" size=2 value=500> meters';
  html += '&nbsp;&nbsp;<input type=button onclick="searchAround();" value="Search">'
  html += '<p><a href="javascript:displayInfoWindow()">Back<a>';
  width = 250;
  height = 120;
  loc = MVSdoGeometry.createPoint(foi.x,foi.y);
  mapview.displayInfoWindow(loc, html, width, height, "MVInfoWindowStyle1");
}

// --------------------------------------------------------------------------------
// callServer()
// --------------------------------------------------------------------------------
function callServer(url, query, handler)
{
  var req = getXMLHttpRequest();
  req.open("POST", url, true);
  req.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  req.onreadystatechange = function() {
    try {
      if (req.readyState == 4)
        if (req.status==200)
          handler(req.responseXML);
        else
          alert ('Server call failed - '+req.status+' '+req.statusText);
    }
    catch (e) {
      alert(e);
    }
  }
  req.send(query);
}

// --------------------------------------------------------------------------------
// getXMLHttpRequest()
// Get the XMLHttpRequest object (browser-dependent)
// --------------------------------------------------------------------------------
function getXMLHttpRequest ()
{
  if(window.ActiveXObject)
  {
    var req = null ;
    try
    {
      req=new ActiveXObject("Microsoft.XMLHTTP");
    }
    catch(e)
    {
      req=new ActiveXObject("Msxml2.XMLHTTP");
    }
    return req;
  }
  else
    return new XMLHttpRequest();
}

// --------------------------------------------------------------------------------
// clearNode()
// --------------------------------------------------------------------------------
function clearNode(node)
{
  if(node && node.childNodes)
  {
    while(node.childNodes.length>0)
    {
      node.removeChild(node.childNodes[0]) ;
    }
  }
}
