-- Listing 8-32. Rewriting Listing 8-30 with Mile As the Distance Unit
col dist format 9.99
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location, 'SDO_NUM_RES=5 UNIT=MILE',1)='TRUE'
ORDER BY ct.id;

