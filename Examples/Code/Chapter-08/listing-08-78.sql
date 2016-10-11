-- Listing 8-78. Identifying the Exact Set of Buildings Intersecting a Helicopter Trajectory Using SDO_ANYINTERACT
SELECT id FROM trip_route t, city_buildings c
WHERE SDO_ANYINTERACT(c.geom, t.trajectory)='TRUE';
