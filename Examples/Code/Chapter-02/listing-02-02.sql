-- Listing 2-2. Inserting aValue for the SDO_GEOMETRY Column in an Oracle Table
INSERT INTO us_restaurants_new VALUES
(
 1,
 'PIZZA HUT',
 SDO_GEOMETRY
 (
  2001, -- SDO_GTYPE attribute: "2" in 2001 specifies dimensionality is 2.
  NULL, -- other fields are set to NULL.
  SDO_POINT_TYPE -- Specifies the coordinates of the point
  (
  -87, -- first ordinate, i.e., value in longitude dimension
  38, -- second ordinate, i.e., value in latitude dimension
  NULL -- third ordinate, if any
  ),
  NULL,
  NULL
 )
);
