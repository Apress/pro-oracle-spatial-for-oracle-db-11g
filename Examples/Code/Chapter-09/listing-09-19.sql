-- Listing 9-19. Identifying Customers in the Intersection of Sales Regions 51 and 43
SELECT COUNT(*)
FROM customers ct
WHERE SDO_RELATE
(
  ct.location,
  (
    SELECT SDO_GEOM.SDO_INTERSECTION(sra.geom, srb.geom, 0.5)
    FROM sales_regions sra, sales_regions srb
    WHERE sra.id = 51 and srb.id = 43
  ),
  'mask=anyinteract'
)='TRUE';
