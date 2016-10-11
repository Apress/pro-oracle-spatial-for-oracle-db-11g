-- Listing 4-20. Storing the Point Coordinates in the SDO_ORDINATES Array Instead of SDO_POINT
INSERT INTO geometry_examples VALUES
(
  '2-D POINT stored in SDO_ORDINATES',
  '2-dimensional Point at coordinates (-79, 37) with srid set to 8307',
  SDO_GEOMETRY
  (
    2001, -- SDO_GTYPE format: D00T. Set to 2001 for as a 2-dimensional point
    8307, -- SDO_SRID
    NULL, -- SDO_POINT attribute set to NULL
    SDO_ELEM_INFO_ARRAY -- SDO_ELEM_INFO attribute (see Table 4-2 for values)
    (
      1, -- Offset is 1
      1, -- Element-type is 1 for a point
      1 -- Interpretation specifies # of points. In this case 1.
    ),
    SDO_ORDINATE_ARRAY -- SDO_ORDINATES attribute
    (
      -79, -- Ordinate value for Longitude
      37 -- Ordinate value for Latitude
    )
  )
);
