-- Listing 4-8. Selecting an SRID for the Southern Texas Region from the MDSYS.CS_SRS Table
SELECT cs_name, srid, wktext
FROM MDSYS.CS_SRS
WHERE WKTEXT LIKE 'PROJCS%'
AND CS_NAME LIKE '%Texas%Southern%'
AND ROWNUM=1;
