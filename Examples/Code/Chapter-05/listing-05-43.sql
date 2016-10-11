-- Listing 5-43. Removing Duplicate Vertices
SELECT SDO_UTIL.REMOVE_DUPLICATE_VERTICES
(
  SDO_UTIL.EXTRACT
  (
    SDO_GEOMETRY
    (
      2007, NULL, NULL,
      SDO_ELEM_INFO_ARRAY(1,1003,3, 5, 1003, 1),
      SDO_ORDINATE_ARRAY
      (
        1,1,2,2,
        3,3, 4, 3, 4,4, 3,4, 3,4,3,3
      )
    ),
    2
  ),
  0.00005
)
FROM dual;
