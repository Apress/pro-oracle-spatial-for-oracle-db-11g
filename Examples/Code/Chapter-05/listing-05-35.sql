-- Listing 5-35. Validation on the Composite Surface in Figure 5-3 (a)
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY -- first argument to validate is geometry
  (
    3003, -- 3-D Polygon/Surface type
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(
      1, 1006, 2, -- Composite Surface with 2 Polygons
      1, 1003, 1, -- 1st polygon
      16, 1003, 1 -- 2nd polygon
    ),
    SDO_ORDINATE_ARRAY (
      0,0,0, 2,0,0, 2,2,0, 0,2,0, 0,0,0, -- vertices of first polygon
      1,1,0, 3,1,0, 3,3,0, 1,3,0, 1,1,0 -- vertices of second polygon
    )
  ),
0.5 -- second argument: tolerance
) is_valid FROM DUAL;
