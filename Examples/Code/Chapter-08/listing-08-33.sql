-- Listing 8-33. Rewriting Listing 8-31 with Mile As the Distance Unit
col dist format 9.99
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN
(ct.location, comp.location, 'SDO_BATCH_SIZE=100 UNIT=MILE', 1 )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;
