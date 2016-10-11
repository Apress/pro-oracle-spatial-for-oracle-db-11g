-- Listing 16-4. Specifying LAYER_GTYPE During Spatial Index Creation
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX PARAMETERS('LAYER_GTYPE=POINT');
