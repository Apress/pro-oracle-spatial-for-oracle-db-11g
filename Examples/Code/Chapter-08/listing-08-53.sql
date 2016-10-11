-- Listing 8-53. Spatial Operator with Multiple Hints in a SQL Statement with Two Tables
SELECT /*+ ORDERED */ ct.id, ct.name
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_WITHIN_DISTANCE
(ct.location, comp.location, 'DISTANCE=0.25 UNIT=MILE ' )='TRUE'
ORDER BY ct.id ;
