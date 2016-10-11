-- Listing 4-14. Finding an EPSG Equivalent for SRID 41155
SELECT sdo_cs.find_proj_crs(41155, 'FALSE') epsg_srid FROM DUAL;
