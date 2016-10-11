-- Listing E-9. Get the Points in Each Block As aMultipoint Collection SDO_GEOMETRY
SELECT blk_id, SDO_PC_PKG.TO_GEOMETRY(
r.points, -- LOB containing the points
r.num_points, -- # of points in the LOB
3, -- Total dimensionality of the points in the LOB
8307 -- SRID
) FROM qryres r;
