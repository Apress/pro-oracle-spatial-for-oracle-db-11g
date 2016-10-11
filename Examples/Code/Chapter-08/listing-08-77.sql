-- Listing 8-77. Identifying the Buildings Intersecting a Helicopter Trajectory Using SDO_FILTER
SELECT id FROM trip_route t, city_buildings c
WHERE SDO_FILTER(c.geom, t.trajectory)='TRUE'
ORDER BY id;
