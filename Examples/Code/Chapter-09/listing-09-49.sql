-- Listing 9-49. Union of All Sales Regions to Obtain Business Coverage
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom, 0.5)) coverage
FROM sales_regions;
