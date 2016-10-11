-- Listing 4-23. Two-Dimensional Line String Connected by Arcs
INSERT INTO geometry_examples VALUES
(
  'ARCSTRING',
  '2-D arc connecting A(Xa=>1,Ya=>1),B(Xb=>2, Yb=>2), C(Xc=>2,Yc=>1)',
  SDO_GEOMETRY
  (
    2002, -- SDO_GTYPE: D00T. Set to 2002 as it is a 2-dimensional line string
    32774, -- SDO_SRID
    NULL, -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1, -- Offset is 1
      2, -- Element-type is 2 for a LINE STRING
      2 -- Interpretation is 2 if line string is connected by ARCs.
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      1,1, -- Xa, Ya values
      2,2, -- Xb, Yb values
      2,1 -- Xc, Yc values
    )
  )
);
