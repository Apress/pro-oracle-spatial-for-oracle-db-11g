-- Listing 5-44. Example of SDO_UTIL.APPEND
SELECT
SDO_UTIL.APPEND
(
  SDO_UTIL.EXTRACT
  (
    SDO_GEOMETRY
    (
      2007, NULL, NULL,
      SDO_ELEM_INFO_ARRAY(
        1,1003,3, -- First element is as a rectangle polygon
        5, 1003, 1
      ),
      SDO_ORDINATE_ARRAY(
        1,1, 2,2,
        3,3, 4,3,
        4,4, 3,4,
        3,4, 3,3
      )
    ),
    1
  ),
  SDO_UTIL.REMOVE_DUPLICATE_VERTICES
  (
    SDO_GEOMETRY
    (
      2007, NULL, NULL,
      SDO_ELEM_INFO_ARRAY(1,1003,3, 5, 1003, 1),
      SDO_ORDINATE_ARRAY
      (
        1,1, 2,2,
        3,3, 4,3,
        4,4, 3,4,
        3,4, 3,3
      )
    ),
    0.00005
  )
) combined_geom
FROM dual;
