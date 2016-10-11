-- Listing 7-2. Simple Spatial Query
SELECT c.name, c.phone_number
  FROM branches b, customers c
 WHERE b.id=42
   AND SDO_WITHIN_DISTANCE (c.location,b.location,'distance=0.25 unit=mile')
       = 'TRUE';
