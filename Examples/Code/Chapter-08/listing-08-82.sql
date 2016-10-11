-- Listing 8-82. Identifying the Units for Vertical Coordinate System SRID 5702
SELECT coord_sys_name
FROM sdo_coord_sys a, sdo_crs_vertical b
WHERE b.srid=5702
AND a.coord_sys_id = b.coord_sys_id;
