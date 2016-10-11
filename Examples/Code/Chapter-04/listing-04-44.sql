-- Listing 4-44. Example SQL for Buildings Modeled As a Collection
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Building as a Collection',
  '3-dimensional collection as combination of a composite solid and 2 surfaces'
  SDO_GEOMETRY
  (
    3004,           -- SDO_GTYPE format: D00T. Set to 3004 for a 3-dimensional Collection
    NULL,           -- No coordinate system
    NULL,           -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1, 1008, 4,   -- Descriptor for a composite solid of 4 simple solids
      1, 1007, 3,   -- Simple solid as a solid Box
      7, 1007, 3,   -- Simple solid as a solid box
      13, 1007, 3,  -- Simple solid as a solid box
      19, 1007, 3,  -- Simple solid as a solid box,
      25, 1003, 3,  -- Descriptor for Door as a polygon
      31, 1003, 3   -- Descriptor for Window as a polygon
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
      2.5,0,3.5, 4,2,4,
      -- min-corner and max-corner for the door,
      2.75, 0, 4, 3.25, 1, 4,
      -- min-corner and max-corner for the window,
      2.5, 2, 4, 3.5, 3, 4
    )
  )
);


