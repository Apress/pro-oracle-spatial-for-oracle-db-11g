-- Listing 5-31. Using the diminfo Parameter in the VALIDATE_GEOMETRY_WITH_CONTEXT Function
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY -- first argument to validate is geometry
  (
    2001, -- point type
    NULL,
    SDO_POINT_TYPE(-80,20,NULL), -- point is <-80,20> and is out of range.
    NULL,
    NULL
  ),
  SDO_DIM_ARRAY -- second argument is diminfo (of type SDO_DIM_ARRAY)
  (
    SDO_DIM_ELEMENT('X', 0, 50, 0.5), -- lower, upper bound range is 0 to 50
    SDO_DIM_ELEMENT('Y', 0, 50, 0.5) -- lower, upper bound range is 0 to 50
  )
) is_valid FROM DUAL;

