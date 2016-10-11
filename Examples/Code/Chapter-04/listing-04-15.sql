-- Listing 4-15. Finding the Source Geographic SRID and the projection_conversion ID for SRID 41155 (EPSG 32041)
SELECT projection_conv_id cid, source_geog_srid src_srid FROM
SDO_COORD_REF_SYS
WHERE srid=32041;
