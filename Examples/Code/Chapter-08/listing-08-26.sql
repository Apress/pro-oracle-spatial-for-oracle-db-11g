-- Listing 8-26. SDO_NN Operator Retrieving the Five Nearest Customers to a Specific Competitor
SELECT ct.id, ct.name, ct.customer_grade
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location)='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;
