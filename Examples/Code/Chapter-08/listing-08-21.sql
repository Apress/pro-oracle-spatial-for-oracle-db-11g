-- Listing 8-21. SDO_WITHIN_DISTANCE Operator Retrieving All Customers in a Quarter-Mile Radius of
-- a Competitor Store and Also Reporting Their Distances
col dist format 999
SELECT ct.id, ct.name,
SDO_GEOM.SDO_DISTANCE(ct.location, comp.location, 0.5, ' UNIT=YARD ') dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_WITHIN_DISTANCE
(ct.location, comp.location, 'DISTANCE=0.25 UNIT=MILE' )='TRUE'
ORDER BY ct.id;

