// --------------------------------------------------------------------------------
// Global variables
// --------------------------------------------------------------------------------

// Customize the following to fit your environment
var baseURL           = "http://"+document.location.host+"/mapviewer";
var datasourceName    = "SPATIAL";
var baseMapName       = "US_CITY_MAP";
var mapSRID           = 8307;
var defaultLocation   = 0;

// Zoom levels for theme visibility
var minVisibleZoomLevel = 13;
var maxWholeImageLevel = 15;
var minClickableZoomLevel = 16;

// Set defaults for the "auto refresh" and "show details" options
var autoRefresh = false;
var showDetails = false;

// This is the difference between the overview map and the main map.
// For example, when the main map is zoomed in at zoom level 16, then the overview map is at zoom level 10.
var overviewZoom    = 6;

// The following variables are used to manage the display of the event details
var foiList;                      // Array that contains the FOI data for all visible FOIs
var pageSize     = 24;            // Maximum number of point events to show on a page

// Fixed locations
// Each entry of the array contains the folllowing:
// - name of the location,
// - X and Y coordinates of the location (the map will be centered on that point)
// - zoom level of the map
// The loadMainMap() procedure takes the index of a location as input
var locations = new Array (
  new Array ("San Francisco, CA", -122.43302833333328, 37.7878425, 16),
  new Array ("Washington, DC",    -77.016167,          38.90505,   16)
)

// List of FOI themes.
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

var mapview = null;

var currentFOIloc;
var currentFOIdata;


// --------------------------------------------------------------------------------
// loadMainMap()
//
// This is the main entry point of the application. All other functions are
// either called from here, or are called from events (mouse click, scale change, etc)
// --------------------------------------------------------------------------------

function loadMainMap(chosenLocation)
{

  // Define initial map center and scale based on chosen location
  var location;;
  if (chosenLocation)
    location = chosenLocation;
  else
    location = defaultLocation;
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

  // Add a marquee zoom control
  var toolBar =
  '<div style="background-color:white; border:1px solid black;">'+
  '&nbsp;Marquee Zoom:&nbsp;'+
  '<input id="marqueezoom" type="checkbox" value="marqueezoom" onclick="toggleMarqueeZoom(this)" unchecked/>'+
  '</div>'
  md = new MVMapDecoration(toolBar, 0, 0) ;
  mapview.addMapDecoration(md);

  // Add a copyright notice
  mapview.addCopyRightNote("Powered by Oracle Maps");

  // Setup an overview map as a collapsible decoration and add it to the map
  ovcontainer = new MVMapDecoration(null,null,null,160,120) ;
  ovcontainer.setCollapsible(true);
  mapview.addMapDecoration(ovcontainer);
  var over=new MVOverviewMap(ovcontainer.getContainerDiv(),overviewZoom);
  mapview.addOverviewMap(over)

  // Setup FOI layers and add to map
  for (i in foiThemes) {
    theme = new MVThemeBasedFOI(foiThemes[i],datasourceName+"."+foiThemes[i]);
    theme.setBringToTopOnMouseOver(true);
    theme.enableInfoTip(true);
    theme.setQueryWindowMultiplier(1);      // Only load FOIs in current map window
    theme.enableInfoWindow(false);           // Will use our own info window via an event listener
    theme.addEventListener('mouse_click', displayInfoWindow) ;
    theme.setMinVisibleZoomLevel(minVisibleZoomLevel);
    theme.setMaxWholeImageLevel(maxWholeImageLevel);
    theme.setMinClickableZoomLevel(minClickableZoomLevel);
    theme.enableImageCaching(true);         // Cache FOI images (they won't change)
    theme.setAutoRefresh(autoRefresh);      // Enable or disable auto refresh
    mapview.addThemeBasedFOI(theme);
  }

  // Setup event listeners
  mapview.addEventListener("recenter",          mapRecenterEvent);
  mapview.addEventListener("zoom_level_change", mapZoomEvent);
  mapview.addEventListener("mouse_right_click", showRightClickMenu);
  mapview.addEventListener("mouse_click",       removeRightClickMenu);

  // Setup control panel
  setupControlPanel()

  // Enable mouse wheel scrolling
  mapview.setMouseWheelZoomEnabled();

  // Display the map and update status
  mapview.display();
}

// --------------------------------------------------------------------------------
// setupControlPanel()
// This sets up the select list of FOI themes as well as the direct links
// to the hard-coded locations and the refresh button
// --------------------------------------------------------------------------------
function setupControlPanel()
{
  // List of selectable themes
  var html = '<form name="controlPanel">';
  html += '<b>Select Themes to Display</b>';
  html += '<dl>';
  for (i in foiThemes) {
    html += '<dt>' +
      '<input type="checkbox" id="checkedTheme" name="checkedTheme" value="' + foiThemes[i] + '" onClick="toggleTheme(this)" checked />' +
      '<img src=' + baseURL + '/omserver?sty=m.' + foiThemes[i] + '&ds=' + datasourceName +'&f=png&w=12&h=12&aa=true" >' +
      foiThemeLabels[i];
  }
  html += '</dl>';

  // Add "select all/select none" links
  html +=
    '<b>Select:</b>&nbsp;<a href="javascript:toggleAllThemes(true)" >All</a>&nbsp;<A href="javascript:toggleAllThemes(false)" >None</A>';

  // Add list selector
  html +=
    '<p><input type="checkbox" name="showDetails" onclick="toggleShowDetails(this);">Show Details';

  // Add autorefresh selector
  html +=
    '<br><input type="checkbox" name="autoRefresh" onclick="toggleAutoRefresh(this);">Auto Refresh';

  // Add refresh button
  html +=
    '<br><input type=button onclick="refreshAllThemes();" value="Refresh">';

  // Add direct links
  html += '<p><b>Direct Links</b>';
  html += '<dl>';
  for (i in locations) {
    html += '<dt>' +
      '<a href="javascript:loadMainMap('+i+')">'+locations[i][0]+'</a>';
  }
  html += '</dl>';

  html += '</form>';
  document.getElementById("PANEL_CONTROL").innerHTML=html;

  // Initial settings for autoRefresh and showDetails toggles
  document.controlPanel.autoRefresh.checked = autoRefresh;
  document.controlPanel.showDetails.checked = showDetails;
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
function mapZoomEvent (oldZoomLevel, newZoomLevel)
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
// toggleShowDetails()
// --------------------------------------------------------------------------------
function toggleShowDetails(checkBox)
{
  showDetails = checkBox.checked;
  if (showDetails)
    updateInfoPanel();
  else
    clearInfoPanel();
  refreshStatus();
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
  showDetails = document.controlPanel.showDetails.checked;
  if (showDetails)
    updateInfoPanel();
  else
    clearInfoPanel();
  refreshStatus();
}


// --------------------------------------------------------------------------------
// displayInfoWindow()
// Displays the information window when a FOI object is clicked.
// --------------------------------------------------------------------------------
function displayInfoWindow(loc, foi)
{
  var html = '';
  html += '<b>Id: </b>'+foi.attrs[1]+'<br>';
  html += '<b>Phone: </b>'+foi.attrs[3]+'<br>';
  html += '<p><a href="javascript:showFOIDetails()">Details<a>';
  html += '&nbsp;&nbsp;<a href="javascript:deleteFOI('+foi.attrs[0]+','+foi.attrs[1]+')">Delete<a>';
  html += '&nbsp;&nbsp;<a href="javascript:zoomToLevel(19)">Zoom<a>';
  width = 200;
  height = 120;
  mapview.displayInfoWindow(loc, html, width, height, "MVInfoWindowStyle1", "&nbsp;&nbsp;"+foi.name+"&nbsp;&nbsp;");
  currentFOIloc = loc;
  currentFOIdata = foi;
}

// --------------------------------------------------------------------------------
// locateFOI ((themeName, foiId)
// Find the FOI identified by its theme name and unique id
// then display its info window
// --------------------------------------------------------------------------------
function locateFOI (themeName, foiId)
{
  var foi = getFoiData (themeName, foiId)
  if (foi) {
    loc = MVSdoGeometry.createPoint(foi.x,foi.y);
    displayInfoWindow(loc, foi);
  }
}

// --------------------------------------------------------------------------------
// getFoiData ((themeName, foiId)
// This function finds the data of a FOI object using its unique ID
// --------------------------------------------------------------------------------
function getFoiData (themeName, foiId)
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
// Shows details about one selected FOI in a popup window
// --------------------------------------------------------------------------------
function showFOIDetails()
{
  loc = currentFOIloc;
  foi = currentFOIdata;
  var html = '<h2>'+foi.name+'</h2>';
  for (var i=1; i<foi.attrs.length; i++)
    html += '<b>'+foi.attrnames[i]+'</b>:&nbsp;'+foi.attrs[i]+'<br>';
  document.getElementById("PANEL_INFO").innerHTML=html;
}

// --------------------------------------------------------------------------------
// updateInfoPanel()
// List all currently visible FOIs in the right panel (PANEL_INFO)
// Do this only if FOIs are clickable, i.e. if the current zoom level is >= minClickableZoomLevel
// --------------------------------------------------------------------------------
function updateInfoPanel()
{
  if (mapview.getZoomLevel() >= minClickableZoomLevel) {
    var n = document.controlPanel.checkedTheme.length;
    foiList = new Array();
    clearInfoPanel();
    for (var i=0; i<n; i++) {
      var themeName = document.controlPanel.checkedTheme[i].value;
      var themeVisible = document.controlPanel.checkedTheme[i].checked;
      var theme = mapview.getThemeBasedFOI(themeName);
      if (themeVisible) {
        foiList = concatArray(foiList,theme.getFOIData());
      }
    }
    if (foiList.length > 0)
      displayFOIPage(1);
  }
}

// --------------------------------------------------------------------------------
// displayFOIPage()
// Display one page of the FOIs in the events list
// --------------------------------------------------------------------------------
function displayFOIPage(pageNr)
{
  clearInfoPanel();
  var html = '<table>';
  var firstRow = (pageNr-1)*pageSize;
  var numRows = (firstRow+pageSize < foiList.length) ? pageSize : foiList.length-firstRow;
  var numPages = Math.ceil(foiList.length/pageSize);
  for (var i=firstRow; i<firstRow+numRows; i++) {
    html += '<tr><td>' +
      '<img src=' + baseURL + '/omserver?sty=m.' + foiThemes[foiList[i].attrs[0]-1] + '&ds=' + datasourceName +'&f=png&w=12&h=12&aa=true" >' +
      '<a href="javascript:locateFOI(\'' + foiThemes[foiList[i].attrs[0]-1] +
      '\',\'' + foiList[i].id + '\')">'+ foiList[i].attrs[1] + '</a></td>' +
      '<td>'+ foiList[i].attrs[2] + '&nbsp;('+foiList[i].attrs[3] +')</td></tr>';
  }
  html += '</table><br>';
  if (numPages > 1) {
    if (pageNr <= 1)
      html += 'Prev';
    else
      html += '<a href="javascript:displayFOIPage('+(pageNr-1)+')">Prev</a>';
    html += '&nbsp;&nbsp;';
    if (pageNr >= numPages)
      html += 'Next';
    else
      html += '<a href="javascript:displayFOIPage('+(pageNr+1)+')">Next</a>';
    html += '&nbsp;&nbsp;&nbsp;Page '+pageNr+'/'+numPages;
  }
  document.getElementById("PANEL_INFO").innerHTML=html;
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
  var mapCenter = mapview.getCenter();
  var x = mapCenter.getPointX().toString().substr(1,10);
  var y = mapCenter.getPointY().toString().substr(1,10);
  var n = 0;
  for (var k in foiThemes) {
    n = n + countFOIs(mapview.getThemeBasedFOI(foiThemes[k]));
  }
  document.getElementById("PANEL_STATUS").innerHTML = "<b>Center: </b>"+x+" "+y+
    "&nbsp;&nbsp;<b>Zoom Level: </b>"+mapview.getZoomLevel()+
    "&nbsp;&nbsp;<b>Features: </b>"+n;
}

// --------------------------------------------------------------------------------
// countFOIs()
// Count the number of FOIs displayed for this layer
// --------------------------------------------------------------------------------
function countFOIs (theme)
{
  if (theme) {
    var fois = theme.getFOIData();
    if (fois)
      return fois.length;
    else
      return 0;
  }
  else
    return 0;
}
// --------------------------------------------------------------------------------
// showRightClickMenu()
// Display the right-click menu offering various options:
// - creating a new point
// - zooming at preset levels
// --------------------------------------------------------------------------------
function showRightClickMenu()
{
  // Disable marquee zoom mode
  enableMarqueeZoom(false);

  // Get location of point just clicked
  var loc = mapview.getMouseLocation();

  // Remove previous menu (if any)
  mapview.removeFOI("right_click_menu");

  // Add the right click menu to the map
  var html = "<div id='right_click_menu'></div>"
  var menu = MVFOI.createHTMLFOI("right_click_menu", loc, html, -2, -2);
  menu.setInfoTip(null);
  menu.setInfoWindow(null, 0, 0);
  mapview.addFOI(menu);

  // Build the menu
  menu = document.getElementById('right_click_menu') ;
  menu.appendChild(createMenuItem("Insert New Customer", enterNewFOI)) ;
  menu.appendChild(createMenuItem("Zoom to City Level", zoomToCityLevel)) ;
  menu.appendChild(createMenuItem("Zoom to Street Level", zoomToStreetLevel)) ;
  menu.appendChild(createMenuItem("Search", searchFOIs)) ;
  menu.style.height = menu.childNodes.length+'em';
  menu.style.backgroundColor = '#ffffff' ;
  menu.style.border='1px solid black' ;
  menu.style.width = '10em' ;
}

// --------------------------------------------------------------------------------
// removeRightClickMenu()
// --------------------------------------------------------------------------------
function removeRightClickMenu()
{
  mapview.removeFOI("right_click_menu") ;
}

// --------------------------------------------------------------------------------
// createMenuItem()
// --------------------------------------------------------------------------------
function createMenuItem(label, listener)
{
  var item = document.createElement('div') ;
  item.innerHTML = label;

  // Setup mouseover actions for the menu item
  item.onmouseover =
    function()
    {
      this.style.backgroundColor = "#336699" ;
      this.style.color = "#ffffff" ;
    }
  item.onmouseout =
    function()
    {
      this.style.backgroundColor = "transparent" ;
      this.style.color = "#000000" ;
    }

  // Setup the function to call when the item is selected
  if(listener)
  {
    item.onmousedown =
      function(event)
      {
        listener() ;
      }
  }
  return item ;
}

// --------------------------------------------------------------------------------
// zoomToLevel()
// Centers the map on the current mouse location, at the chosen level
// --------------------------------------------------------------------------------
function zoomToLevel(zoomLevel)
{
  // Remove the right-click menu
  removeRightClickMenu();

  // Get location of point just clicked
  var loc = mapview.getMouseLocation();

  // Zoom at city level
  mapview.setCenterAndZoomLevel(loc, zoomLevel);
}
function zoomToCityLevel () {zoomToLevel(9)}
function zoomToStreetLevel () {zoomToLevel(12)}

// --------------------------------------------------------------------------------
// searchFOIs()
// Centers the map on the current mouse location, at the chosen level
// --------------------------------------------------------------------------------
function searchFOIs()
{
  alert ("Search function not implemented");
}

// --------------------------------------------------------------------------------
// enterNewFOI()
// Create a new point at the current mouse location.
// This function shows an information window pointing to the mouse location. The
// informmation window contains a form that allows the user to enter attributes for
// the new point.
// --------------------------------------------------------------------------------
function enterNewFOI()
{
  // Remove the right-click menu
  removeRightClickMenu();

  // Get location of point just clicked
  var loc = mapview.getMouseLocation();
  var locX = loc.getPointX();
  var locY = loc.getPointY();

  // Setup input form in info window
  var html = '<b>'+T_ENTER_DETAILS+'</b>';
  html += '<br><br><form name="enterNewFOI">';

  // Category selector
  html += '<b>'+T_CATEGORY+':</b>&nbsp;<select id="newFoiCategory">'
  for (i in foiThemeLabels) {
    html += '<option value="' + foiThemeCategoryCodes[i] + '"> '+ foiThemeLabels[i] + '</option>';
  }
  html += '</select>';

  // Show object coordinates
  html += '<br><b>X:</b> '+locX + '<br><b>Y:</b> '+locY;

  // Add insert and cancel buttons
  html +=
    '<br><br><input type=button onclick="insertFOI('+locX+','+locY+')" value="'+T_INSERT+'">';
  html +=
    '&nbsp;<input type=button onclick="mapview.removeInfoWindow()" value="'+T_CANCEL+'">';
  html +=
    '</form>';

  width = 250;
  height = 160;
  mapview.displayInfoWindow(loc, html, width, height, "MVInfoWindowStyle2");
}

// --------------------------------------------------------------------------------
// insertFOI()
// --------------------------------------------------------------------------------
function insertFOI(locX, locY)
{
  // Construct the URL to the JSP that will perform the insertion
  var category = document.getElementById("newFoiCategory").value;
  var insertURL = "addPoint.jsp";
  var queryString = 'posx='+locX+'&posy='+locY+'&cat='+category+'&save=save';

  // Call the JSP via an asynchronous XMLHTTPRequest call
  var response = callServer(insertURL, queryString, insertFOIComplete);
}
// --------------------------------------------------------------------------------
// insertFOIComplete()
// This function gets called when the anynchronous XMLHTTPRequest call completes
// --------------------------------------------------------------------------------
function insertFOIComplete(response)
{
  // Extract the response (JSON) returned by the server JSP
  var data = eval('(' + response + ')');
  // Clear the information window
  mapview.removeInfoWindow();
  // Refresh the FOIs. This will make the new point appear on the map (and on the side list, it enabled)
  refreshAllThemes();
}

// --------------------------------------------------------------------------------
// deleteFOI()
// --------------------------------------------------------------------------------
function deleteFOI(id, cat)
{
  var ok = confirm (T_DO_YOU_WANT_TO_DELETE);
  if (!ok)
    return;
  var deleteURL = "deletePoint.jsp";
  var queryString = 'id='+id+'&cat='+cat+'&save=save';
  var response = callServer(deleteURL, queryString, deleteFOIComplete);
}
function deleteFOIComplete(response)
{
  var data = eval('(' + response + ')');
  mapview.removeInfoWindow();
  refreshAllThemes();
}

// --------------------------------------------------------------------------------
// callServer(url)
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
          handler(req.responseText);
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

// --------------------------------------------------------------------------------
// concatArray()
// --------------------------------------------------------------------------------
function concatArray(a1, a2)
{
  if (!a1)
    return a2;
  var k = a1.length;
  var a = a1;
  for (var i in a2)
    a1[k++] = a2[i];
  return a;

}
