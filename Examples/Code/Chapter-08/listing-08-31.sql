-- Listing 8-31. SDO_NN Operator Retrieving the Five GOLD Customers Nearest to a Specific Competitor Along with Their Distances
SELECT ct.id, ct.name, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN(ct.location, comp.location, 'SDO_BATCH_SIZE=100', 1 )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;

