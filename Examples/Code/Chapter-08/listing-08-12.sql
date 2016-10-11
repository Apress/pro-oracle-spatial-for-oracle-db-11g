-- Listing 8-12. Creating an Index for Specific-Type (Point) Geometries
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('LAYER_GTYPE=POINT');


