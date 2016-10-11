-- Listing 9-23. Identifying Customers in an Exclusive Zone of a Competitor
SELECT ct.id, ct.name
FROM exclusive_region_for_comp_2 excl, customers ct
WHERE SDO_RELATE(ct.location, excl.geom, 'mask=anyinteract')='TRUE'
ORDER BY ct.id;
