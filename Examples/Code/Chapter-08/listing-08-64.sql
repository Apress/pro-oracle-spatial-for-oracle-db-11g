-- Listing 8-64. Obtaining the Five Customers Nearest to Each Competitor When the customers Table Has
a Local Partitioned Index
SELECT id, name FROM
(
  SELECT /*+ ORDERED */ a.id , a.name, SDO_NN_DISTANCE(1) dist
  FROM competitors b, customers a
  WHERE b.id=1
  AND SDO_NN(a.location, b.location, 'SDO_NUM_RES=5' , 1)='TRUE' ORDER BY dist
)
WHERE ROWNUM<=5
ORDER BY id;
