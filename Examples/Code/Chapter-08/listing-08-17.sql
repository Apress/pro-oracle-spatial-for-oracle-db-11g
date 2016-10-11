-- Listing 8-17. Estimating the Size of a Spatial Index on the location Column of the customers Table
SELECT sdo_tune.estimate_rtree_index_size
(
'SPATIAL', -- schema name
'CUSTOMERS', -- table name
'LOCATION' -- column name on which the spatial index is to be built
) sz
FROM dual;
