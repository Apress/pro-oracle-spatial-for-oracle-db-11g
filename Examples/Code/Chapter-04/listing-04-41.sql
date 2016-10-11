-- Listing 4-41. Simple Solid with an Inner Hole That Touches Both Top and Bottom Faces
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Simple Solid with inner hole touching top/bottom faces',
  '3-dimensional Solid with 8 rectangle polygons as its boundary ',
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
      8,          -- # of composing elements; element triplets for each element follow
      1, 1003,3,  -- Axis-aligned Rectangle element descriptor for left face
      7, 1003,3,  -- Axis-aligned Rectangle element descriptor for right face
      13,1003,3,  -- Axis-aligned Rectangle element descriptor for back face
      19,1003,3,  -- Axis-aligned Rectangle element descriptor for front face
      25,1003,1,  -- Element descriptor for ABCDEFA on Top Face
      46,1003,1,  -- Element descriptor for AGEDHBA on Top Face
      67,1003,1,  -- Element descriptor for equivalent ABCDEFA on Bottom Face
      88,1003,1   -- Element descriptor for equivalent AGEDHBA on Bottom Face
    ),
    SDO_ORDINATE_ARRAY
    (
      -- Outer side walls
      4,2,2, 2,0,2, -- Back face
      2,0,4, 4,2,4, -- Front face
      4,0,2, 4,2,4, -- Right side face
      2,2,4, 2,0,2, -- Left side face
      --
      -- Inner side walls
      2.5,0,2.5, 3.5,2,2.5, -- Back Face
      3.5,2,3.5, 2.5,0,3.5, -- Front Face
      2.5,0,2.5, 2.5,2,3.5, -- Left Face
      3.5,2,3.5, 3.5,0,3.5, -- Right Face
      --
      -- Coordinates for vertices A,B,C,D,E,F,A on top face
      2,2,4, 2.5,2,3.5, 2.5,2,2.5, 3.5,2,2.5, 4,2,2, 2,2,2, 2,2,4,
      -- Coordinates for vertices A,G,E,D,H,B,A on top face
      2,2,4, 4,2,4, 4,2,2, 3.5,2,2.5, 3.5,2,3.5, 2.5,2,3.5, 2,2,4,
      -- Coordinates for polygon equivalent to ABCDEFA on bottom face
      2,0,4, 2,0,2, 4,0,2, 3.5,0,2.5, 2.5,0,2.5, 2.5,0,3.5, 2,0,4,
      -- Coordinates for polygon equivalent to AGEDHBA on bottom face
      2,0,4, 2.5,0,3.5, 3.5,0,3.5, 3.5,2,2.5, 4,0,2, 4,0,4, 2,0,4
    )
  )
);

