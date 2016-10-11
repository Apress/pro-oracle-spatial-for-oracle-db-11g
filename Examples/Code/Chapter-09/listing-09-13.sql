-- Listing 9-13. Identifying Suppliers in a Quarter-Mile Buffer Around a Competitor
SELECT s.id
FROM suppliers s, competitors_sales_regions cs
WHERE SDO_GEOM.RELATE (s.location, 'ANYINTERACT', cs.geom, 0.5) = 'TRUE'
AND cs.id=1;
