-- Listing 4-27. Compound Line String Example
INSERT INTO geometry_examples VALUES
(
  'COMPOUND LINE STRING',
  '2-D Compound Line String connecting A,B, C by a line and C, D, E by an arc',
  SDO_GEOMETRY
  (
    2002,       -- SDO_GTYPE: D00T. Set to 2002 as it is a 2-dimensional Line String
    32774,      -- SDO_SRID
    NULL,       -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1,        -- Offset is 1
      4,        -- Element-type is 4 for Compound Line String
      2,        -- Interpretation is 2 representing number of subelements
      1, 2, 1,  -- Triplet for first subelement connected by line
      5, 2, 2   -- Triplet for second subelement connected by arc; offset is 5
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      1,1,      -- Xa, Ya values for vertex A
      2,3,      -- Xb, Yb values for vertex B
      3,1,      -- Xc, Yc values for vertex C
      4,2,      -- Xd, Yd values for vertex D
      5,3       -- Xe, Ye values for vertex E
    )
  )
);
