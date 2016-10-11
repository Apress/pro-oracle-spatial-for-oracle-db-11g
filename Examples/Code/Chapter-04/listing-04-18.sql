-- Listing 4-18. Point Data in geometry_examples
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  'POINT',
  '2-dimensional Point at coordinates (-79,37) with srid set to 8307',
  SDO_GEOMETRY
  (
    2001, -- SDO_GTYPE format: D00T. Set to 2001 for a 2-dimensional point
    8307, -- SDO_SRID (geodetic)
    SDO_POINT_TYPE
    (
      -79, -- ordinate value for Longitude
      37, -- ordinate value Latitude
      NULL -- no third dimension (only 2 dimensions)
    ),
    NULL,
    NULL
  )
);
