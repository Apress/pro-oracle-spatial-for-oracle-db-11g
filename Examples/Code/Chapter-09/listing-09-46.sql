-- Listing 9-46. Computing the Three-Dimensional Extent of the Buildings in the city_buildings Table
SELECT SDO_AGGR_MBR(geom) extent FROM city_buildings;
