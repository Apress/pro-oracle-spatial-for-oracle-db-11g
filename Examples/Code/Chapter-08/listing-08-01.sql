-- Listing 8-1. SDO_WITHIN_DISTANCE Spatial Operator in SQL
SELECT COUNT(*)
FROM branches b , customers c
WHERE b.id=1
AND SDO_WITHIN_DISTANCE
(c.location, b.location, 'DISTANCE=0.5 UNIT=MILE')='TRUE';
