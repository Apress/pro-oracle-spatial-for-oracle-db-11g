-- Listing 16-2. Correcting a Self-Crossing Polygon Geometry Using SDO_UNION
SELECT SDO_GEOM.SDO_UNION
(
  SDO_GEOMETRY -- self-crossing 'polygon' geometry
  (
    2003, -- A polygon type geometry: invalid because edges cross
    NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1 ),
    SDO_ORDINATE_ARRAY
    (
      2,2,
      3,3.5,
      2,5,
      5,5,
      3,3.5,
      5,2,
    2,2
    )
  ),
  SDO_GEOMETRY -- self-crossing 'polygon' geometry (repeated)
  (
    2003,
    NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1 ),
    SDO_ORDINATE_ARRAY
    (
      2,2,
      3,3.5,
      2,5,
      5,5,
      3,3.5,
      5,2,
      2,2
    )
  ),
  0.0000005
) valid_gm FROM DUAL;
