-- Listing 8-40. SDO_RELATE Operator Retrieving All Customers in a Quarter-Mile Buffer Zone of a Competitor Store
SELECT ct.id, ct.name
FROM competitors_sales_regions comp, customers ct
WHERE comp.id=1
AND SDO_RELATE(ct.location, comp.geom, 'MASK=ANYINTERACT ' )='TRUE'
ORDER BY ct.id;
