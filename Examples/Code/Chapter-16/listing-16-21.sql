-- Listing 16-21. Splitting the current_month Partition into march and current_month Partitions
ALTER TABLE weather_patterns
SPLIT PARTITION current_month AT ('2004-04-1') INTO
(
 PARTITION march,
 PARTITION current_month
);
