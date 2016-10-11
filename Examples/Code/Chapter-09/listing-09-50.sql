-- Listing 9-50. Finding the Coverage of sales_regions Using SDO_AGGR_CONVEXHULL
SELECT SDO_AGGR_CONVEXHULL(SDOAGGRTYPE(geom, 0.5)) coverage
FROM sales_regions;

