-- Listing 5-33. Validating a Line String with Duplicate Points
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY -- first argument to validate is geometry
  (
    2002, -- Line String type
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1), -- Line String
    SDO_ORDINATE_ARRAY (
      1,1, -- first vertex
      2,2, -- second vertex
      2,2 -- third vertex: same as second
    )
  ),
  0.5 -- second argument: tolerance
) is_valid FROM DUAL;
