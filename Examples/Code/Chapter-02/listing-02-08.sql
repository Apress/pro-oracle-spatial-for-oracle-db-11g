-- Listing 2-8. Verifying That a Spatial Install Is Successful
SELECT COMP_NAME, STATUS
FROM DBA_REGISTRY
WHERE COMP_NAME = 'Spatial';
