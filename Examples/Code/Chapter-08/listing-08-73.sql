-- Listing 8-73. SDO_JOIN Operator Retrieving All Customers Whose MBRs Intersect the MBRs of Competitor
Regions (Filter Operation Is Used)
SELECT COUNT(DISTINCT ct.id)
FROM competitors_sales_regions comp, customers ct,
TABLE
(
  SDO_JOIN
  (
    'competitors_sales_regions', 'geom', -- first table and column
    'customers', 'location' -- second table and column
  )
) jn
WHERE ct.rowid=jn.rowid2
AND comp.rowid = jn.rowid1;
