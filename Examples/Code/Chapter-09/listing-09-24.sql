-- Listing 9-24. Combining Listings 9-22 and 9-23
SELECT ct.id, ct.name
FROM sales_regions sr, competitors_sales_regions csr, customers ct
WHERE csr.id=2 AND sr.id=6
AND SDO_RELATE
(
  ct.location,
  SDO_GEOM.SDO_DIFFERENCE(csr.geom, sr.geom, 0.5),
  'mask=anyinteract'
)='TRUE'
ORDER BY ct.id;
