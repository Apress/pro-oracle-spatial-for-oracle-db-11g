-- Listing 8-45. Identifying Sales Regions That Intersect a Specific Sales Region (id=51)
SELECT sr1.id
FROM sales_regions sr2, sales_regions sr1
WHERE sr2.id=51
AND sr1.id <> 51
AND SDO_RELATE(sr1.geom, sr2.geom, 'MASK=ANYINTERACT' )='TRUE';
