Listing 16-15. Creating a Local Partitioned Spatial Index
CREATE INDEX weather_patterns_sidx ON weather_patterns(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX LOCAL;
