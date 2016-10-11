-- Listing 8-13. Creating an R-tree Index with Dimensionality Specified
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('SDO_INDX_DIMS=2');
