-- Listing 8-71. SDO_JOIN Operator Analyzing the Number of Customers Inside All the Competitor Regions
SELECT COUNT(DISTINCT ct.id)
FROM competitors comp, customers ct,
TABLE
(
  SDO_JOIN
  (
    'competitors', 'location',  -- first table and the SDO_GEOMETRY column
    'customers', 'location',    -- second table and the SDO_GEOMETRY column
    'DISTANCE=200 UNIT=METER'   -- specify mask relationship
  )
) jn
WHERE ct.rowid=jn.rowid2
AND comp.rowid = jn.rowid1;

