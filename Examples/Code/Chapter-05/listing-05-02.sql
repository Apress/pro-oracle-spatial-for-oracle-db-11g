-- Listing 5-2. Inserting a Polygon Geometry into the sales_regions Table
INSERT INTO sales_regions VALUES
(
  10000,        -- SALES_REGIONS ID
  SDO_GEOMETRY  -- use the SDO_GEOMETRY constructor
  (
    2003,       -- A two-dimensional Polygon
    8307,       -- SRID is GEODETIC
    NULL,       -- SDO_POINT_TYPE is null as it is not a point
    SDO_ELEM_INFO_ARRAY (1, 1003, 1), -- A polygon with just one ring
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES field
    (
      -77.04487, 38.9043742, -- coordinates of first vertex
      -77.046645, 38.9040983, -- other vertices
      -77.04815, 38.9033127, -77.049155, 38.9021368,
      -77.049508, 38.9007499, -77.049155, 38.899363, -77.048149, 38.8981873,
      -77.046645, 38.8974017, -77.04487, 38.8971258, -77.043095, 38.8974017,
      -77.041591, 38.8981873, -77.040585, 38.899363, -77.040232, 38.9007499,
      -77.040585, 38.9021368, -77.04159, 38.9033127, -77.043095, 38.9040983,
      -77.04487, 38.9043742 -- coordinates of last vertex same as first vertex
    )
  )
);
