-- Listing 4-39. SQL for Simple Solid in Figure 4-27 (a)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Simple Solid as a Solid Box',
  '3-dimensional Solid with just the 2 corner vertices ',
  SDO_GEOMETRY
  (
    3008,           -- SDO_GTYPE format: D00T. Set to 3008 for a 3-dimensional Solid
    NULL,           -- No coordinate system
    NULL,           -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,            -- Offset of a Simple solid element
      1007,         -- Etype for a Simple solid
      3             -- Solid Box type: only two corner vertices are specified
    ),
    SDO_ORDINATES_ARRAY
    (
      2,0,2, 4,2,4  -- min-corner and max-corner for the solid
    )
  )
);
