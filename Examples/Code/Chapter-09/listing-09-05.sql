-- Listing 9-5. Using the SDO_DISTANCE Function to Determine the Distance Between Building 16 and the Helicopter Trajectory
SELECT cbldg.id,
SDO_GEOM.SDO_DISTANCE(cbldg.geom, tr.trajectory, 0.05, 'UNIT=foot') dist
FROM trip_route tr, city_buildings cbldg
WHERE cbldg.id=16;
