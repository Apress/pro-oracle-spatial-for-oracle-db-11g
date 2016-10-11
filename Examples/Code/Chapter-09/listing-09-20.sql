-- Listing 9-20. SDO_UNION of Two Geometries
SELECT count(*)
FROM
(
  SELECT SDO_GEOM.SDO_UNION (sra.geom, srb.geom, 0.5) geom
  FROM sales_regions srb, sales_regions sra
  WHERE sra.id=51 and srb.id=43
) srb, customers sra
WHERE SDO_RELATE(sra.location, srb.geom, 'mask=anyinteract')='TRUE';
