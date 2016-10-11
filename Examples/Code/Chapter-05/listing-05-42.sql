-- Listing 5-42. Validation on the Result of SDO_UTIL.EXTRACT
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY
  (
    2003, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1, 1003, 1),
    SDO_ORDINATE_ARRAY
    (
      3, 3, -- first vertex coordinates
      4, 3, -- second vertex coordinates
      4, 4, -- third vertex coordinates
      3, 4, -- fourth vertex coordinates
      3, 4, -- fifth vertex coordinates
      3, 3  -- sixth vertex coordinates (same as first for polygon)
    )
  ),
  0.00005 -- tolerance
) FROM dual;
