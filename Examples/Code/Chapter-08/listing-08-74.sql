-- Listing 8-74. Rewriting Listing 8-73 to Restrict the Scope of SDO_JOIN to Just the Customers in the GOLD Partition
-- First, drop and re-create the index as a local partitioned index
DROP INDEX customers_sidx;
CREATE INDEX customers_sidx on customers(location)
  INDEXTYPE IS mdsys.spatial_index LOCAL;
-- Now perform the query on a specific partition
SELECT COUNT(DISTINCT ct.id)
FROM competitors_sales_regions comp, customers PARTITION(GOLD) ct,
TABLE
(
  SDO_JOIN
  (
    'competitors_sales_regions', 'geom',    -- first table and column
    'customers', 'location',                -- second table and column
    NULL,                                   -- parameters list is set to NULL
    0,                                      -- preserve_join_order set to default value
    NULL,                                   -- competitors_sales_region is the entire table
    'GOLD'                                  -- GOLD partition of customers table
  )
) jn
WHERE ct.rowid=jn.rowid2
AND comp.rowid = jn.rowid1;
