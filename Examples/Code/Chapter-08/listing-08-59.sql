-- Listing 8-59. SDO_NN Operator Retrieving the Five Customers Nearest to Each Competitor Using the Function-Based Index
SELECT /*+ ORDERED */ ct.id, ct.name, ct.customer_grade
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN
(
  gcdr_geometry (ct.street_number,ct.street_name, ct.city, ct.state, ct.postal_code),
  comp.location,
  'SDO_NUM_RES=5'
)='TRUE'
ORDER BY ct.id;
