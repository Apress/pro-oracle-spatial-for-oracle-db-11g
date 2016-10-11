-- Listing 8-83. Identifying the Closest Buildings to a Helicopter Trajectory Within 200 Feet
SELECT id FROM trip_route t, city_buildings c
WHERE SDO_WITHIN_DISTANCE(
  c.geom, t.trajectory,
 'distance = 200 unit=FOOT ') = 'TRUE'
ORDER BY id;
