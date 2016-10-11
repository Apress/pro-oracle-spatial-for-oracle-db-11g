-- Listing 9-48. Union of Three Sales Regions (ids 43, 51, and 2)
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom, 0.5)) union_geom
FROM sales_regions
WHERE id=51 or id=43 or id=2 ;

