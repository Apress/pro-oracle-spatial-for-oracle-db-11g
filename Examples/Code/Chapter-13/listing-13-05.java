// Listing 13-5. Building a Legend

String[][][] legend = new String[][][]
{
  {
    {"Map Legend",  null,               "true",   null, "false"},
    {"Counties",    "C.US MAP YELLOW",  "false",  null, "false"},
    {"Rivers",      "C.RIVER",          "false",  null, "false"},
    {"Parks",       "C.PARK FOREST",    "false",  null, "false"}
  },
  {
    {"",            null,               "false",  null, "true" },
    {"Interstates", "L.PH",             "false",  null, "false"},
    {"Major Cities","M.CITY HALL 4",    "false",  null, "false"}
  }
};

mv.setMapLegend(
  "white",        // Fill color
  "128",          // Fill opacity
  "red",          // Stroke color
  "medium",       // Legend size
  "SOUTH_EAST",   // Legend position
  legend          // Legend array
);
