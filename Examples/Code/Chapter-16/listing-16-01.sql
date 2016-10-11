-- Listing 16-1. Correcting the Orientation of a Polygon Geometry Using TO_CURRENT
SELECT SDO_MIGRATE.TO_CURRENT
(
  SDO_GEOMETRY
  (
    2003, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1 ),
    SDO_ORDINATE_ARRAY
    (
    2,2, -- Vertices specified in clockwise order
    3,3.5,
    5,2,
    2,2
    )
  ),
  SDO_DIM_ARRAY
  (
    SDO_DIM_ELEMENT('1', -180, 180, 0.0000005),
    SDO_DIM_ELEMENT('2', -90, 90, 0.0000005)
  )
) FROM DUAL;

