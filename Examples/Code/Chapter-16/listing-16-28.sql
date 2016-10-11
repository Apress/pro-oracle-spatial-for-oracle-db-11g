-- Listing 16-28. Performing SDO_RELATE on a Subquery Returning a Subset of Customers
SELECT ct.id, ct.name
FROM competitors_sales_regions comp,
(SELECT c.name FROM customers c WHERE c.name LIKE '%SCHOOL') ct
WHERE comp.id=1
AND SDO_RELATE(ct.location, comp.geom, 'MASK=ANYINTERACT ' )='TRUE'
ORDER BY ct.id;
