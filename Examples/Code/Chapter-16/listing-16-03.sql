-- Listing 16-3. Nearest-Neighbor Query on the customers Table
SELECT COUNT(*)
FROM branches b, customers c
WHERE b.id=1 AND SDO_NN(c.location, b.location, 'SDO_NUM_RES=100')='TRUE';
