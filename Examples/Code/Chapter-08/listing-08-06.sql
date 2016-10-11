-- Listing 8-6. Creating a Spatial Index on the location Column of the customers Table
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;
