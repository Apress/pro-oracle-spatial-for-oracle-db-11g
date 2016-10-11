-- Listing 16-29. Performing SDO_GEOM.RELATE on a Subquery Returning a Subset of Customers
SELECT ct.id, ct.name
FROM competitors_sales_regions comp,
(SELECT c.name FROM customers c WHERE c.name LIKE '%SCHOOL') ct
WHERE comp.id=1
AND SDO_GEOM.RELATE(ct.location, 'ANYINTERACT', comp.geom, 0.5 )='TRUE'
ORDER BY ct.id;
