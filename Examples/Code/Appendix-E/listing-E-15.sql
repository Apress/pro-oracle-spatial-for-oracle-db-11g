-- Listing E-15. Initializing, Inserting, and Populating a TIN with an Input Set of Points
-- Initialize a PointCloud object and populate it using the points in INPTAB.
DECLARE
tin SDO_TIN;
BEGIN
-- Initialize the TIN object.
tin := SDO_TIN_PKG.INIT(
'TIN_TAB', -- Table that has the SDO_TIN column defined
'TIN', -- Column name of the SDO_TIN object
'TIN_BLKTAB', -- Table to store blocks of the TIN
'blk_capacity=6000', -- max # of points per block
SDO_GEOMETRY(2003, 8307, NULL, -- Extent: 2 in 2003 indicates that
-- ptn_dimensionality is 2. This means only the first 2 dimensions are
-- used in partitioning the input point set. The index on the block table
-- will also have a dimensionality of 2 in this case.
--
SDO_ELEM_INFO_ARRAY(1,1003,3),
SDO_ORDINATE_ARRAY(-180, -90, 180, 90)
),
0.00000005, -- Tolerance for TIN
3, -- Total number of dimensions is 3; the third dimension is stored
-- but not used for partitioning
NULL -- This parameter is for enabling compression but always set to
-- NULL in Oracle 11gR1;
);
-- Insert the TIN object into the "base" table.
INSERT INTO tin_tab (tin) VALUES (tin);
-- Create the blocks for the TIN.
SDO_TIN_PKG.CREATE_TIN(
tin, -- Initialized TIN object
'INPTAB' -- Name of input table to ingest into the point cloud
'RESTAB' -- Name of output table that stores the points
-- (with addl. Columns ptn_id,pt_id) );
END;
/
