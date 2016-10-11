-- Listing 9-30. Identifying Interstates Shorter Than 1 Mile
SELECT interstate
FROM us_interstates
WHERE SDO_GEOM.SDO_LENGTH(geom, 0.5, 'unit=mile') < 1;
