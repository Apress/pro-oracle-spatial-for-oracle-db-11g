-- Listing 7-1. Extracting Coordinates
SELECT b.name,
       b.location.sdo_point.x b_long,
       b.location.sdo_point.y b_lat
FROM   branches b
WHERE  b.id=42 ;
