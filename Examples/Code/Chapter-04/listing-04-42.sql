-- Listing 4-42. Example SQL for Composite Solid of Figure 4-29
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Composite Solid of 4 simple solids',
  '3-dimensional composite solid ',
  SDO_GEOMETRY
  (
    3008,     -- SDO_GTYPE format: D00T. Set to 3008 for a 3-dimensional Solid
    NULL,     -- No coordinate system
    NULL,     -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,      -- Offset of the composite solid element
      1008,   -- Etype for a composite solid
      4,      -- Number of cimple solids making up the composite.
      -- The simple solid descriptors next.
      1, 1007, 3,   -- Simple solid as a solid Box
      7, 1007, 3,   -- Simple solid as a solid box
      13, 1007, 3,  -- Simple solid as a solid box
      19, 1007, 3   -- Simple solid as a solid box
    ),
    SDO_ORDINATE_ARRAY
    (
      -- min-corner and max-corner for the West wing
      2,0,2, 2.5,2,4,
      -- min-corner and max-corner for the East wing,
      3.5, 0,2, 4,2,3.5,
      -- min-corner and max-corner for the North wing,
      2.5,0,2, 3.5,2,2.5,
      -- min-corner and max-corner for the South wing,
      2.5,0,3.5, 4,2,4
    )
  )
);
