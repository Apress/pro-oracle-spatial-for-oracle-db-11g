-- Listing 4-25. Rectangular Polygon Example
INSERT INTO geometry_examples VALUES
(
  'RECTANGLE POLYGON',
  '2-D rectangle polygon with corner points A(Xa, Ya), C (Xc, Yc)',
  SDO_GEOMETRY
  (
    2003,     -- SDO_GTYPE: D00T. Set to 2003 as it is a 2-dimensional polygon
    32774,    -- SDO_SRID
    null,     -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1,      -- Offset is 1
      1003,   -- Element-type is 1003 for (an outer) POLYGON
      3       -- Interpretation is 3 if polygon is a RECTANGLE
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      1,1,    -- Xa, Ya values
      2,2     -- Xc, Yc values
    )
  )
);
