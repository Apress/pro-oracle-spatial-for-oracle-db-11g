-- Listing 8-41. Identifying a DISJOINT Relationship
SELECT ct1.id, ct1.name
FROM customers ct1
WHERE NOT EXISTS
(
  SELECT 'X'
  FROM competitors_sales_regions comp, customers ct2
  WHERE comp.id=1
  AND ct2.id = ct2.id
  AND SDO_RELATE(ct2.location, comp.geom, 'MASK=ANYINTERACT')='TRUE'
);
