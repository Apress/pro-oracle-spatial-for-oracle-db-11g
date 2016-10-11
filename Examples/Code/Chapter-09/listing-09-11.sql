-- Listing 9-11. Identifying Buildings That Intersect the Helicopter Trajectory
SELECT cbldg.id
FROM city_buildings cbldg, trip_route tr
WHERE SDO_GEOM.RELATE (cbldg.geom, 'ANYINTERACT', tr.trajectory, 0.5) = 'TRUE';
