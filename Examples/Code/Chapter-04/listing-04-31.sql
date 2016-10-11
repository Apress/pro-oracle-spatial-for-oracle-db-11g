-- Listing 4-31. Three-Dimensional Line String Geometry Example
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D LineString',
  '3-dimensional LineString from coordinates (2,0,2) to (4,2,4) ',
  SDO_GEOMETRY
  (
    3002,   -- SDO_GTYPE format: D00T. Set to 3002 for a 3-dimensional line
    NULL,   -- No coordinate system
    NULL,   -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,    -- Offset for ordinates in SDO_ORDINATE_ARRAY
      2,    -- Line String typ
      1     -- Connected by straight lines
    ),
    SDO_ORDINATES_ARRAY
    (
      2,    -- ordinate value for first dimension for first point
      0,    -- ordinate value for second dimension for first point
      2,    -- ordinate value for third dimension for first point
      4,    -- ordinate value for first dimension for second point
      2,    -- ordinate value for second dimension for second point
      4     -- ordinate value for third dimension for second point
    )
  )
);
