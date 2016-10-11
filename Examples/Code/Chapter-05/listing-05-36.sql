-- Listing 5-36. Validating the Simple Solid in Figure 5-4
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_GEOMETRY(3008, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(
      1, 1007, 1, -- Solid element
      1, 1006, 5, -- Composite surface with 5 polygons
      1, 1003,1, 16, 1003, 1, 31, 1003, 1, 46, 1003, 1, 61, 1003, 1
    ),
    SDO_ORDINATE_ARRAY(
      0, 0, 0, 0, 4, 0, 4, 4, 0, 4, 0, 0, 0, 0, 0,
      4, 4, 4, 0, 4, 4, 0, 0, 4, 4, 0, 4, 4, 4, 4,
      0, 0, 0, 4, 0, 0, 4, 0, 4, 0, 0, 4, 0, 0, 0,
      0, 0, 0, 0, 0, 4, 0, 4, 4, 0, 4, 0, 0, 0, 0,
      4, 4, 4, 4, 0, 4, 4, 0, 0, 4, 4, 0, 4, 4, 4
    )
  ),
0.5
) is_valid FROM DUAL;
