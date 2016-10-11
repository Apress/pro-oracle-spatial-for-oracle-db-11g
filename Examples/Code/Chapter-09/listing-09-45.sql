-- Listing 9-45. Finding the Extent of a Set of Geometries Using SDO_AGGR_MBR
SELECT SDO_AGGR_MBR(location) extent FROM branches;
