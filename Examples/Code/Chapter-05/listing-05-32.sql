-- Listing 5-32. Using the tolerance Parameter in the VALIDATE_GEOMETRY_WITH_CONTEXT Function
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY -- first argument to validate is geometry
  (
    2001, -- point type
    NULL,
    SDO_POINT_TYPE(-80,20,NULL), --point not out of range as no range specified
    NULL,
    NULL
  ),
  0.5
) is_valid FROM DUAL;
