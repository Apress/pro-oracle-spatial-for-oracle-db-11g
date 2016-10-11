-- Listing 9-10. Identifying Customers Who Interact with a Competitor’s Sales Region
SELECT ct.id, ct.name
FROM customers ct, competitors_sales_regions comp
WHERE SDO_GEOM.RELATE (ct.location, 'ANYINTERACT', comp.geom, 0.5) = 'TRUE'
AND comp.id=1
ORDER BY ct.id;
