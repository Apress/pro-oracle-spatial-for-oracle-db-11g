-- Listing 8-37. Creating Indexes on Sales Regions of Competitors/Branches
-- Metadata for Sales_regions table: copied from the metadata for Branches table
INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'SALES_REGIONS','GEOM', DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME='BRANCHES';
-- Metadata for Competitors_regions table:
-- copied from the metadata for Branches table
INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'COMPETITORS_SALES_REGIONS','GEOM', DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME='COMPETITORS';
-- Index-creation for Sales_regions table
CREATE INDEX sr_sidx ON sales_regions(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;
-- Index-creation for Competitors_sales_regions table
CREATE INDEX cr_sidx ON competitors_sales_regions(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;
