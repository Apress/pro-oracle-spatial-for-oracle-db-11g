-- Listing 9-9. Identifying Customers in a Competitor’s Sales Region
SELECT ct.id, ct.name
FROM customers ct, competitors_sales_regions comp
WHERE SDO_GEOM.RELATE (ct.location, 'INSIDE', comp.geom, 0.5) = 'INSIDE'
AND comp.id=1
ORDER BY ct.id;
