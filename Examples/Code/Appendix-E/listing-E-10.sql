-- Listing E-10. Selecting the Point IDs in Each Block As an Array of <ptn_id, point_id> Pairs
SELECT SDO_PC_PKG.GET_PT_IDS(
r.points, -- LOB containing the points
r.num_points, -- # of points in the LOB
3 -- Total dimensionality of the points in the LOB
) FROM resqry r WHERE num_points >0;

