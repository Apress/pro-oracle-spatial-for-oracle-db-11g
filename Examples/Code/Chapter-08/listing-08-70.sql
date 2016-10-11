-- Listing 8-70. SDO_RELATE Operator Retrieving All Customers Inside (and Touching the Border of) Each Competitor Region
SELECT COUNT(DISTINCT ct.id)
FROM competitors comp, customers ct
WHERE SDO_WITHIN_DISTANCE (ct.location, comp.location, 'DISTANCE=200 UNIT=METER ' )='TRUE';
