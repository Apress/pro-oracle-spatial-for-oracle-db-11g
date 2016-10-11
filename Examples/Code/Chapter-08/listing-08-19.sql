-- Listing 8-19. Spatial Operator Usage in a SQL Statement
SELECT COUNT(*)
FROM branches b, customers c
WHERE b.id=1
AND SDO_WITHIN_DISTANCE
(c.location, b.location, 'DISTANCE=0.5 UNIT=MILE') = 'TRUE';
