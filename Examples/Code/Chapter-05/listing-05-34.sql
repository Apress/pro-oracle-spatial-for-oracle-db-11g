-- Listing 5-34. Validation on a Self-Crossing Geometry in Figure 5-2 (a)
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY
  (
    2003,         -- 2-D Polygon
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY
    (
      1, 1003,1   -- Polygonal ring connected by lines
    ),
    SDO_ORDINATE_ARRAY
    (
      2,2,        -- first vertex
      3,3.5,      -- second vertex. Edge 1 is between previous and this vertex.
      2,5,
      5,5,
      3,3.5,      -- fifth vertex. Edge 4 is between previous and this vertex.
      5,2,
      2,2
    )
  ),
  0.000005
)
FROM dual;
