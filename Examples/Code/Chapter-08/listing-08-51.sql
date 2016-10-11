-- Listing 8-51. Creating an Index on customer_grade and Rerunning Listing 8-50
CREATE INDEX cust_grade ON customers(customer_grade);
col dist format 9999
SELECT ct.id, ct.customer_grade, SDO_NN_DISTANCE(1) dist
FROM competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN(ct.location, comp.location, 'SDO_BATCH_SIZE=100', 1 )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;
