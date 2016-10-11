-- Listing 8-68. ALTER INDEX ... REBUILD with PARAMETERS Clause
ALTER INDEX customers_sidx REBUILD
PARAMETERS ('layer_gtype=POINT');
