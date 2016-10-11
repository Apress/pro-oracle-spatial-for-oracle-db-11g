-- Listing 8-66. Setting the Degree of Parallelism to 2 for a Table and Creating the Index
ALTER TABLE customers PARALLEL 2 ;      -- set degree
DROP INDEX customers_sidx;              -- drop existing index
CREATE INDEX customers_sidx ON customers(location)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL; -- no need to specify degree
