-- Listing 4-21. Four-Dimensional Point Example
INSERT INTO geometry_examples VALUES
(
  '4-D POINT',
  '4-dimensional Point at (Xa=>2, Ya=>2, Za=>2, La=>2) with srid set to NULL',
  SDO_GEOMETRY
  (
    4001, -- SDO_GTYPE: D00T. Set to 4001 as it is a 4-dimensional point
    NULL, -- SDO_SRID
    NULL, -- SDO_POINT_TYPE is null
    SDO_ELEM_INFO_ARRAY(1,1,1), -- Indicates a point element
    SDO_ORDINATE_ARRAY(2,2,2,2) -- Store the four ordinates here
  )
);
