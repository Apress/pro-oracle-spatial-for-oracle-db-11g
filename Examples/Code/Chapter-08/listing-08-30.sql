-- Listing 8-30. SDO_NN Operator Retrieving the Five Customers Nearest to a Specific Competitor Along with Their Distances
col dist format 999
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location, 'SDO_NUM_RES=5',1)='TRUE'
ORDER BY ct.id;

