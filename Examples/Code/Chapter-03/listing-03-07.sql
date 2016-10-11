-- Listing 3-7. Updating a location Column Using an SDO_GEOMETRY Constructor
UPDATE customers
SET location =
SDO_GEOMETRY
(
2001, -- Specify that location is a point
8307, -- Specify coordinate system id
SDO_POINT_TYPE(-77.06, 38.94, NULL), -- Specify coordinates here
NULL,
NULL
)
WHERE id=1;
