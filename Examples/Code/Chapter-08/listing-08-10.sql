-- Listing 8-10. Creating an Index with the INITIAL and NEXT Extents for an Index Table
CREATE INDEX customers_sidx ON customers(location)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('TABLESPACE=TBS_3 NEXT=5K INITIAL=10K');

