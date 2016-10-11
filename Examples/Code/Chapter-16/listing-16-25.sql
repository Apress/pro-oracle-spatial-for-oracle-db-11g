-- Listing 16-25. Renaming the Merged Monthly Partition As a Year Partition
ALTER INDEX weather_patterns_sidx RENAME PARTITION jan TO p2004;
