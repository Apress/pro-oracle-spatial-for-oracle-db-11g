-- Listing 4-43. Example SQL for Multisolid of Figure 4-30
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Multi Solid',
  '3-dimensional Multisolid with 2 solid boxes ',
  SDO_GEOMETRY
  (
    3009,         -- SDO_GTYPE format: D00T. Set to 3009 for a 3-dimensional MultiSolid
    NULL,         -- No coordinate system
    NULL,         -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,          -- Offset of a simple solid element
      1007,       -- Etype for a simple solid
      3,          -- Solid box type: only two corner vertices are specified
      7, 1007, 3  -- Solid Box for second solid
    ),
    SDO_ORDINATES_ARRAY
    (
      -- min-corner and max-corner for first solid
      0,0,0, 4,4,4,
      -- min-corner and max-corner for second solid.
      5,0,0, 9,4,4
    )
  )
);
