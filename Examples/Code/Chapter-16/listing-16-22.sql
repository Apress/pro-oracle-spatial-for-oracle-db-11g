-- Listing 16-22. Rebuilding the Indexes for the “Split” Partitions
ALTER INDEX weather_patterns_sidx REBUILD PARTITION march;
ALTER INDEX weather_patterns_sidx REBUILD PARTITION current_month;
