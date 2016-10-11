-- Listing 16-23. Merging the Partitions for jan and feb into a Single Partition
ALTER TABLE weather_patterns
  MERGE PARTITIONS jan, feb INTO PARTITION janfeb;
