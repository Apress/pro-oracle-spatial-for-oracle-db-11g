-- Listing 8-63. SDO_WITHIN_DISTANCE Operator on a Partitioned Table
SELECT /*+ ORDERED */ ct.id, ct.name
FROM competitors comp, customers ct
WHERE comp.id=1
AND customer_grade='GOLD'
AND SDO_WITHIN_DISTANCE (ct.location, comp.location, 'DISTANCE=0.25 UNIT=MILE ' )='TRUE'
ORDER BY ct.id;
