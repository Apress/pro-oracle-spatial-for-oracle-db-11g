-- Listing 4-26. Circular Polygon Example
INSERT INTO geometry_examples VALUES
(
  'CIRCLE POLYGON',
  '2-D circle polygon with 3 boundary points A(Xa,Ya), B(Xb,Yb), C(Xc,Yc)',
  SDO_GEOMETRY
  (
    2003,     -- SDO_GTYPE: D00T. Set to 2003 as it is a 2-dimensional polygon
    32774,    -- SDO_SRID
    NULL,     -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1,      -- Offset is 1
      1003,   -- Element-type is 1003 for (an outer) POLYGON
      4       -- Interpretation is 4 if polygon is a CIRCLE
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      1,1,    -- Xa, Ya values
      3,1,    -- Xb, Yb values
      2,2     -- Xc, Yc values
    )
  )
);
