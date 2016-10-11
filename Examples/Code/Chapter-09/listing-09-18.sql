-- Listing 9-18. Identifying Customers in sales_ intersection_zones
SELECT count(*)
FROM sales_intersection_zones siz, customers ct
WHERE siz.id1=51 AND siz.id2=43
AND SDO_RELATE(ct.location, siz.intsxn_geom, 'mask=anyinteract')='TRUE';
