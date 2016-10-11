-- Listing 4-10. Searching for a Compound Coordinate System for the Texas Region
SELECT srid, coord_ref_sys_name name,
cmpd_horiz_srid hsrid, cmpd_vert_srid vsrid
FROM sdo_coord_ref_sys
WHERE coord_ref_sys_name like '%Texas%'
AND coord_ref_sys_kind='COMPOUND';
