-- Listing 3-12. Selecting SRIDs of Geodetic Coordinate Systems
SELECT SRID
FROM MDSYS.CS_SRS
WHERE WKTEXT LIKE 'GEOGCS%';
