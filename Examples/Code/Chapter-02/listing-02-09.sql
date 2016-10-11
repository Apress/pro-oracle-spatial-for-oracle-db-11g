-- Listing 2-9. Checking for Invalid Objects in a Spatial Installation
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
FROM ALL_OBJECTS
WHERE OWNER='MDSYS' AND STATUS <> 'VALID'
ORDER BY OBJECT_NAME;
