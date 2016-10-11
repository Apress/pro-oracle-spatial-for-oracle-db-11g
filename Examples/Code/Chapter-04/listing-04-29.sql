-- Listing 4-29. Creating a Heterogenous Collection Using SDO_UTIL.APPEND
SELECT SDO_UTIL.APPEND
(
  SDO_GEOMETRY
  (
    2003, 32774, null,
    SDO_ELEM_INFO_ARRAY(1,1003, 3),
    SDO_ORDINATE_ARRAY(1,1, 2,2)
  ),
  SDO_GEOMETRY
  (
    2002, 32774, NULL,
    SDO_ELEM_INFO_ARRAY(1, 2, 2),
    SDO_ORDINATE_ARRAY(2,3, 3,3,4,2)
  )
)
FROM dual;
