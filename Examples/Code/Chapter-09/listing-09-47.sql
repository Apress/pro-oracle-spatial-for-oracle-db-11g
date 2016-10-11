-- Listing 9-47. Finding the Coverage of Branch Locations Using SDO_AGGR_UNION
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(location, 0.5)) coverage
FROM branches;
