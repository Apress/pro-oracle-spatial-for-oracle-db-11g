-- Listing 8-14. Creating an Index with the SDO_DML_BATCH_SIZE Parameter
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('SDO_DML_BATCH_SIZE=5000');

