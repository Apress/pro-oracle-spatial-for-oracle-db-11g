-- Listing 4-36. SQL for Composite Surface in Figure 4-25 (b)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Composite Surface with hole polygons',
  '3-dimensional Composite with 2 rectangle polygons one of which has a hole ',
  SDO_GEOMETRY
  (
    3003,       -- SDO_GTYPE format: D00T. Set to 3003 for a 3-dimensional Surface
    NULL,       -- No coordinate system
    NULL,       -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,        -- Offset of composite element
      1006,     -- Etype for composite surface element
      2,        -- Number of composing Polygons
      1,        -- Offset for ordinates in SDO_ORDINATE_ARRAY
      1003,     -- Etype for Exterior (outer) ring of FIRST polygon
      3,        -- Polygon is an axis-aligned rectangle
      7,        -- Offset for ordinates in SDO_ORDINATE_ARRAY
      2003,     -- Etype for Interior (inner) ring of FIRST polygon
      3,        -- Polygon is an axis-aligned rectangle
      13,       -- Offset for second exterior polygon
      1003,     -- Etype for exterior Ring of SECOND polygon
      3         -- Polygon is an axis-aligned rectangle
    ),
    SDO_ORDINATES_ARRAY
    (
      2, 0, 2,      -- min-corner for exterior ring of first polygon,
      4, 2, 2,      -- max-corner for exterior ring of first polygon
      3, 1, 2,      -- min-corner for interior ring of first polygon
      3.5, 1.5, 2,  -- max-corner for interior ring of first polygon
      2,0, 2,       -- min-corner for second element rectangle
      4,0,4         -- max-corner for second element rectangle
    )
  )
);
