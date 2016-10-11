-- Listing 4-13. Looking Up Details for Vertical Coordinate System ID 5702 in Appropriate Tables
SELECT cs.COORD_SYS_NAME
FROM SDO_CRS_VERTICAL v, SDO_COORD_SYS cs
WHERE v.SRID=5702 and cs.COORD_SYS_ID = v.COORD_SYS_ID;
