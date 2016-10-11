-- Listing 9-25. SDO_XOR of Sales Regions 43 and 51 to Identify Customers Who Are Not Shared Between Them
SELECT count(*)
FROM
(
  SELECT SDO_GEOM.SDO_XOR (a.geom, b.geom, 0.5) geom
  FROM sales_regions srb, sales_regions sra
  WHERE sra.id=51 and srb.id=43
) srb, customers sra
WHERE SDO_RELATE(sra.location, srb.geom, 'mask=anyinteract')='TRUE';
