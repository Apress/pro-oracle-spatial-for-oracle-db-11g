-- Listing 8-15. Creating a Quadtree Type of Spatial Index
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('SDO_LEVEL=8');

