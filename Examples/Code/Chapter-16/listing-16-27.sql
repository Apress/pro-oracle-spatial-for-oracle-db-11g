-- Listing 16-27. Performing SDO_RELATE on a Subset of Customers
SELECT ct.id, ct.name
FROM competitors_sales_regions comp, customers ct
WHERE comp.id=1
AND SDO_RELATE(ct.location, comp.geom, 'MASK=ANYINTERACT ' )='TRUE'
AND ct.name LIKE '%SCHOOL%'
ORDER BY ct.id;
