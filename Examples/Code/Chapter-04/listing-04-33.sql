-- Listing 4-33. Three-Dimensional Rectangle Representation for Polygon of Figure 4-23 (a)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Rectangle Polygon',
  '3-dimensional Polygon from coordinates (2,0,2) to (4,0, 4) ',
  SDO_GEOMETRY
  (
    3003,       -- SDO_GTYPE format: D00T. Set to 3003 for a 3-dimensional polygon
    NULL,       -- No coordinate system
    NULL,       -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,        -- Offset for ordinates of the Exterior Ring in SDO_ORDINATE_ARRAY
      1003,     -- ETYPE for Exterior ring
      3         -- MBR Connected by straight lines
    ),
    SDO_ORDINATES_ARRAY
    (
      2, 0, 2,  -- coordinates for min-corner of Exterior ring
      4, 0, 4   -- coordinates for max-corner of Exterior ring
    )
  )
);
