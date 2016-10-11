-- Listing 5-41. Validation of an Extracted Geometry
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_UTIL.EXTRACT
  (
    SDO_GEOMETRY
    (
      2007, null, null,
      SDO_ELEM_INFO_ARRAY(1,1003,3, 5, 1003, 1),
      SDO_ORDINATE_ARRAY
      (
        1,1,2,2, -- first element of multipolygon geometry
        3,3, 4, 3, 4,4, 3,4, 3,4,3,3 -- second element of multipolygon geometry
      )
    ),
    2 -- element number to extract
  ),
  0.00005
)
FROM dual;
