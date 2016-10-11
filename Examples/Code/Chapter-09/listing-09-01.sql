-- Listing 9-1. Creating Buffers Around Branches
CREATE TABLE sales_regions AS
SELECT id,
SDO_GEOM.SDO_BUFFER(b.location, 0.25, 0.5, 'arc_tolerance=0.005 unit=mile') geom
FROM branches b;
