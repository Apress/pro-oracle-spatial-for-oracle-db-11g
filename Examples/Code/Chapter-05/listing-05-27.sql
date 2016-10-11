-- Listing 5-27. Extruding a Polygon to a Three-Dimensional Solid
SELECT SDO_UTIL.EXTRUDE(
  SDO_GEOMETRY -- first argument to validate is geometry
  (
    2003, -- 2-D Polygon
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(
      1, 1003, 1                -- A polygon element
    ),
    SDO_ORDINATE_ARRAY (
      0,0, 2,0, 2,2, 0,2, 0,0   -- vertices of polygon
    )
  ),
  SDO_NUMBER_ARRAY(-1),         -- Just 1 ground height value applied to all vertices
  SDO_NUMBER_ARRAY(1),          -- Just 1 top height value applied to all vertices
  'FALSE',                      -- No need to validate
  0.5                           -- Tolerance value
) EXTRUDED_GEOM FROM DUAL;
