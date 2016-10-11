-- Listing 8-69. ALTER INDEX ... REBUILDWithout Blocking Any Concurrent Queries
ALTER INDEX customers_sidx REBUILD ONLINE
PARAMETERS ('layer_gtype=POINT');
