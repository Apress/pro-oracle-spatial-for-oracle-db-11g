-- Listing 16-16. Creating a Local Partitioned Spatial Index As "Unusable"
DROP INDEX weather_patterns_sidx;
CREATE INDEX weather_patterns_sidx ON weather_patterns(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX LOCAL UNUSABLE;
