-- Listing 9-16. SDO_INTERSECTION of Two Geometries
CREATE TABLE sales_intersection_zones AS
SELECT sra.id id1, srb.id id2,
SDO_GEOM.SDO_INTERSECTION(a.geom, b.geom, 0.5) intsxn_geom
FROM sales_regions srb, sales_regions sra
WHERE sra.id<> srb.id
AND SDO_RELATE(sra.geom, srb.geom, 'mask=anyinteract' )='TRUE' ;
