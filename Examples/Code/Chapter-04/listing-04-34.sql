-- Listing 4-34. SQL for Polygon with Hole in Figure 4-23 (b)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Rectangle Polygon with Hole',
  '3-dimensional Polygon ',
  SDO_GEOMETRY
  (
    3003,           -- SDO_GTYPE format: D00T. Set to 3003 for a 3-dimensional polygon
    NULL,           -- No coordinate system
    NULL,           -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,            -- Offset for ordinates in SDO_ORDINATE_ARRAY
      1003,         -- Exterior ring etype
      3,            -- Rectangle
      7,            -- Offset for interior ring ordinates in SDO_ORDINATE_ARRAY
      2003,         -- ETYPE for Interior ring
      3             -- Rectangle
    ),
    SDO_ORDINATES_ARRAY
    (
      2, 0, 2,      -- coordinates for min-corner of Exterior ring
      4, 0, 4,      -- coordinates for max-corner of Exterior ring
      3.5, 0, 3.5,  -- coordinates of max-corner of Interior ring
      3, 0, 3       -- coordinates of min-corner of Interior ring
    )
  )
);
