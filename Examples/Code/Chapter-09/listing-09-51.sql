-- Listing 9-51. Finding the Centroid of Customer Locations Using SDO_AGGR_CENTROID
SELECT SDO_AGGR_CENTROID(SDOAGGRTYPE(location, 0.5)) ctrd
FROM customers
WHERE id>100;
