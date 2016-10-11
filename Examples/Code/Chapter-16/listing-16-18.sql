-- Listing 16-18. Rebuilding All UNUSABLE Indexes for a Table Partition
ALTER TABLE weather_patterns REBUIlD PARTITION P1 UNUSABLE LOCAL INDEXES;
