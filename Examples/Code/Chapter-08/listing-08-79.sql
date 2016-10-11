-- Listing 8-79. Identifying the Five Closest Buildings to a Helicopter Trajectory
SET numformat 99999
SELECT id, SDO_NN_DISTANCE(1) dist FROM trip_route t, city_buildings c
WHERE SDO_NN(c.geom, t.trajectory, 'sdo_num_res=3', 1)='TRUE'
ORDER BY dist;
