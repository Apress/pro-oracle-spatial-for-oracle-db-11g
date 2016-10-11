-- Listing 16-20. Adding New Data Using the EXCHANGE PARTITION Clause
CREATE TABLE tmp (gid number, geom sdo_geometry, date varcahr2(32));
INSERT INTO TABLE tmp VALUES (...); --- new data
-- Also include data from current_month partition
INSERT INTO TABLE tmp
SELECT * FROM weather_partitions PARTITION(current_month);
-- Exchange table tmp with "current_month" partition of weather_patterns.
ALTER TABLE weather_patterns
EXCHANGE PARTITION current_month WITH TABLE tmp INCLUDING INDEXES;
