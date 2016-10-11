-- Listing E-5. Initializing, Inserting, and Populating a Point Cloud with an Input Set of Points
-- Initialize a PointCloud object and populate it using the points in INPTAB.
DECLARE
pc sdo_pc;
BEGIN
-- Initialize the point cloud object.
pc := SDO_PC_PKG.INIT(
'PC_TAB', -- Table that has the SDO_POINT_CLOUD column defined
'PC', -- Column name of the SDO_POINT_CLOUD object
'PC_BLKTAB', -- Table to store blocks of the point cloud
'blk_capacity=50', -- max # of points per block
SDO_GEOMETRY(2003, 8307, NULL,
-- Extent: 2 in 2003 in preceding line indicates that
-- ptn_dimensionality is 2. This means only the first 2 dimensions are
-- used in partitioning the input point set. The index on the block table
-- will also have a dimensionality of 2 in this case.
--
SDO_ELEM_INFO_ARRAY(1,1003,3),
SDO_ORDINATE_ARRAY(-180, -90, 180, 90)
),
0.5, -- Tolerance for point cloud
3, -- Total number of dimensions is 3; the third dimension is stored
-- but not used for partitioning
NULL -- This parameter is for enabling compression but always set to
-- NULL in Oracle 11gR1;
);
-- Insert the point cloud object into the "base" table.
INSERT INTO pctab (pc) VALUES (pc);
-- Create the blocks for the point cloud.
SDO_PC_PKG.CREATE_PC(
pc, -- Initialized PointCloud object
'INPTAB' -- Name of input table to ingest into the point cloud
'RESTAB' -- Name of output table that stores the points
-- (with addl. Columns ptn_id,pt_id) );
END;
/
