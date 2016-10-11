-- Listing 4-37. SQL for Composite Surface in Figure 4-26
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Composite Surface2',
  '3-dimensional Composite with 6 rectangle polygons ',
  SDO_GEOMETRY
  (
    3003,           -- SDO_GTYPE format: D00T. Set to 3003 for a 3-dimensional Surface
    NULL,           -- No coordinate system
    NULL,           -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,            -- Offset of composite element
      1006,         -- Etype for composite surface element
      6,            -- Number of composing polygons; element triplets for each follow
      1, 1003,3     -- Axis-aligned Rectangle element descriptor
      7, 1003,3,    -- Axis-aligned Rectangle element descriptor
      13,1003,3,    -- Axis-aligned Rectangle element descriptor
      19, 1003,3,   -- Axis-aligned Rectangle element descriptor
      25, 1003,3,   -- Axis-aligned Rectangle element descriptor
      31,1003,3     -- Axis-aligned Rectangle element descriptor
    ),
    SDO_ORDINATES_ARRAY
    (
      2, 0,2, 4,2,2,  -- min-, max- corners for Back face,
      2,0,4, 4,2,4,   -- min-, max- corners for Front face,
      4,0,2, 4,2,4,   -- min-, max- corners for Right side face,
      2.0.2, 2,2,4,   -- min-, max- corners for Left side face,
      4,0,4, 2,0,2,   -- min-, max- corners for Bottom face,
      4,2,4, 2,2,2    -- min-, max- corners for Top face
    )
  )
);
