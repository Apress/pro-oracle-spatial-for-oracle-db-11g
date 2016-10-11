-- Listing 16-19. Exchanging tmp Data with Partition p1 of weather_patternsWithout Indexes
ALTER TABLE weather_patterns
  EXCHANGE PARTITION current_month
  WITH TABLE tmp EXCLUDING INDEXES;
