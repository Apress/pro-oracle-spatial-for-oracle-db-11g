-- Listing 4-40. Simple Solid with an Inner Hole as in Figure 4-27 (b)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Simple Solid with inner hole',
  '3-dimensional Solid with 6 rectangle polygons as its boundary ',
  SDO_GEOMETRY
  (
    3008,         -- SDO_GTYPE format: D00T. Set to 3008 for a 3-dimensional Solid
    NULL,         -- No coordinate system
    NULL,         -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,          -- Offset of a Simple solid element
      1007,       -- Etype for a Simple solid
      1,          -- Indicates all surfaces are specified explicitly
      1,          -- Offset of composite element
      1006,       -- Etype for composite surface element
      6,          -- # of composing elements; element triplets for each element follow
      1, 1003,3,  -- Axis-aligned Rectangle element descriptor
      7, 1003,3,  -- Axis-aligned Rectangle element descriptor
      13,1003,3,  -- Axis-aligned Rectangle element descriptor
      19, 1003,3, -- Axis-aligned Rectangle element descriptor
      25, 1003,3, -- Axis-aligned Rectangle element descriptor
      31, 1003,3, -- Axis-aligned Rectangle element descriptor
      37, 2006,6, -- Inner composite surface
      37, 2003,3, -- Axis-aligned Rectangle element ; note etype is 2003
      43, 2003,3, -- Axis-aligned Rectangle element descriptor
      49, 2003,3, -- Axis-aligned Rectangle element descriptor
      55, 2003,3, -- Axis-aligned Rectangle element descriptor
      61, 2003,3, -- Axis-aligned Rectangle element descriptor
      67, 2003,3  -- Axis-aligned Rectangle element descriptor
    ),
    SDO_ORDINATE_ARRAY
    (
      --- All polygons oriented such that normals point outward from solid
      ---
      ------- Ordinates for the rectangles of the outer composite surface
      4,2,2, 2,0,2, -- Back face
      2,0,4, 4,2,4, -- Front face
      4,0,2, 4,2,4, -- Right face
      2,2,4, 2,0,2, -- Left face
      4,0,4, 2,0,2, -- Bottom face
      2,2,2, 4,2,4, -- Top face
      ---
      ------- Ordinates for the rectangles of inner/hole composite surface
      -------- representing the atrium
      2.5, 0.5, 2.5, 3.5, 1.5, 2.5, -- Back face
      3.5, 1.5, 3.5, 2.5, 0.5, 3.5, -- Front face
      3.5, 1.5, 3.5, 3.5, 0.5, 2.5, -- Right face
      2.5, 0.5, 2.5, 2.5, 1.5, 3.5, -- Left face
      2.5, 0.5, 2.5, 3.5, 0.5, 3.5, -- Bottom face
      3.5, 1.5, 3.5, 2.5, 1.5, 2.5  -- Top face
    )
  )
);
