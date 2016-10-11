-- Listing 8-28. SDO_NN Operator Retrieving the Five GOLD Customers Nearest to a Competitor
SELECT ct.id, ct.name, ct.customer_grade
FROM competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN(ct.location, comp.location, 'SDO_BATCH_SIZE=100' )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;
