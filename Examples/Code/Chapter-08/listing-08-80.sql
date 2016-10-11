-- Listing 8-80. Identifying the Component SRIDs for Compound Coordinate System 7407
SELECT srid, cmpd_horiz_srid, cmpd_vert_srid
FROM sdo_coord_ref_sys
WHERE srid=7407;
