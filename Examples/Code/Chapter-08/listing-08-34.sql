-- Listing 8-34. Augmenting Listing 8-32 to Limit the Search Space to 0.1 Mile Distance
col dist format 9.99
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location, 'SDO_NUM_RES=5 DISTANCE=0.1 UNIT=MILE',1)='TRUE'
ORDER BY ct.id;
