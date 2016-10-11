-- Listing 5-46. Extracting the Invalid Edge for Listing 5-36
SELECT SDO_UTIL.EXTRACT3D
(
  SDO_GEOMETRY(3008, NULL, NULL,
  SDO_ELEM_INFO_ARRAY(
    1, 1007, 1, -- Solid element
    1, 1006, 5, -- Composite surface with 5 polygons
    1, 1003,1, 16, 1003, 1, 31, 1003, 1, 46, 1003, 1, 61, 1003, 1
  ),
  SDO_ORDINATE_ARRAY(
    0, 0, 0, 0, 4, 0, 4, 4, 0, 4, 0, 0, 0, 0, 0, -- Vertices of 2nd edge bold
    4, 4, 4, 0, 4, 4, 0, 0, 4, 4, 0, 4, 4, 4, 4,
    0, 0, 0, 4, 0, 0, 4, 0, 4, 0, 0, 4, 0, 0, 0,
    0, 0, 0, 0, 0, 4, 0, 4, 4, 0, 4, 0, 0, 0, 0,
    4, 4, 4, 4, 0, 4, 4, 0, 0, 4, 4, 0, 4, 4, 4
  )
),
'0,2,1,1,1' -- LABEL String for extracting the
-----2nd edge of Ring1, Polygon1,Comp Surface1
) edge FROM DUAL;
