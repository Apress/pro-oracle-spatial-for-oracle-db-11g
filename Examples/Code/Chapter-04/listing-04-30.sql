-- Listing 4-30. Three-Dimensional Point Geometry Example
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D POINT',
  '3-dimensional Point at coordinates (2,0,2) ',
  SDO_GEOMETRY
  (
    3001,   -- SDO_GTYPE format: D00T. Set to 3001 for a 3-dimensional point
    NULL,   -- No coordinate system
    SDO_POINT_TYPE
    (
      2,    -- ordinate value for first dimension
      0,    -- ordinate value for second dimension
      2     -- ordinate value for third dimension
    ),
    NULL, -- SDO_ELEM_INFO is not needed as SDO_POINT field is populated
    NULL -- SDO_ORDINATES is not needed as SDO_POINT field is populated
  )
);
