-- Listing 8-52. Usage of Hints with SDO_NN and Other Operators on the Same Table
SELECT /*+ NO_INDEX(ct cust_grade) INDEX(ct customers_sidx) */
ct.id, ct.customer_grade, SDO_NN_DISTANCE(1) dist FROM
competitors comp, customers ct
WHERE comp.id=1
AND ct.customer_grade='GOLD'
AND SDO_NN(ct.location, comp.location, 'SDO_BATCH_SIZE=100', 1 )='TRUE'
AND ROWNUM<=5
ORDER BY ct.id;
