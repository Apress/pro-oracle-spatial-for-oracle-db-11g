-- Listing 8-35. Augmenting Listing 8-33 with a Limit of 0.1 Mile Distance
col dist format 9.99
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN
(ct.location, comp.location,
'SDO_BATCH_SIZE=100 DISTANCE=0.1 UNIT=MILE', 1 )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;

