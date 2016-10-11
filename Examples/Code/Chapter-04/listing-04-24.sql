-- Listing 4-24. Example of a Simple Polygon Connected by Lines
INSERT INTO geometry_examples VALUES
(
  'POLYGON',
  '2-D polygon connecting A(Xa, Ya), B(Xb, Yb), C(Xc, Yc), D(Xd, Yd)',
  SDO_GEOMETRY
  (
    2003,   -- SDO_GTYPE: D00T. Set to 2003 as it is a 2-dimensional polygon
    32774,  -- SDO_SRID
    NULL,   -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1,      -- Offset is 1
      1003,   -- Element-type is 1003 for an outer POLYGON element
      1       -- Interpretation is 1 if boundary is connected by straight lines.
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      1,1,    -- Xa, Ya values
      2,-1,   -- Xb, Yb values
      3,1,    -- Xc, Yc values
      2,2,    -- Xd, Yd values
      1,1     -- Xa, Ya values : Repeat first vertex to close the ring
    )
  )
);
