-- Listing 8-9. Creating a Spatial Index in Tablespace TBS_3
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('TABLESPACE=TBS_3');
