// Listing 13-2. Processing the Map Response

// Get URL to generated Map
imgURL = mv.getGeneratedMapImageURL();

// Get the XML request sent to the server
String mapRequest = mv.getMapRequestString();

// Get the XML response received from the server
String mapResponse = mv.getMapResponseString();

// Get the names of rendered themes
String[] names = mv. GetMapResponseThemeNames();

// Get size and center of new map
double mapSize = mv.getRequestSize();
Point2D center = mv.getRequestCenter();
double cx = center.getX();
double cy = center.getY();

// Get the MBR of the map
double box[] = mv.getMapMBR();
double boxLLX = box[0];
double boxLLY = box[1];
double boxURX = box[2];
double boxURY = box[3];
