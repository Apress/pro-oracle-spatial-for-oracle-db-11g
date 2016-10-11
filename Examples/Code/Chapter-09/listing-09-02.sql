-- Listing 9-2. Creating Buffers Around Competitor Locations
CREATE TABLE COMPETITORS_SALES_REGIONS AS
SELECT id,
SDO_GEOM.SDO_BUFFER(cmp.location, 0.25, 0.5, 'unit=mile arc_tolerance=0.005') geom
FROM competitors cmp

-- Metadata for Sales_regions table
INSERT INTO user_sdo_geom_metadata
SELECT 'SALES_REGIONS',
'GEOM', diminfo, srid FROM user_sdo_geom_metadata
WHERE table_name='BRANCHES';
-- Metadata for Competitors_sales_regions table
INSERT INTO user_sdo_geom_metadata
SELECT 'COMPETITORS_SALES_REGIONS',
'GEOM', diminfo, srid FROM user_sdo_geom_metadata
WHERE table_name='COMPETITORS';

-- Index-creation for Sales_regions table
CREATE INDEX sr_sidx ON sales_regions(geom)
INDEXTYPE IS mdsys.spatial_index;
-- Index-creation for Competitors_sales_regions table
CREATE INDEX cr_sidx ON competitors_sales_regions(geom)
INDEXTYPE IS mdsys.spatial_index;
