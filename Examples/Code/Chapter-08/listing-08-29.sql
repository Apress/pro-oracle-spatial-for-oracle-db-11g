-- Listing 8-29. SDO_NN Operator Retrieving the Five Customers Nearest to a Specific Competitor
SELECT ct.id, ct.name, ct.customer_grade
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location, 'SDO_NUM_RES=5')='TRUE' ;
