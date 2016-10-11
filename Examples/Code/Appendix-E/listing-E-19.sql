-- Listing E-19. Get the Triangles in Each Block As a Collection SDO_GEOMETRY
SELECT blk_id, SDO_TIN_PKG.TO_GEOMETRY(
r.points, -- LOB containing the points
r.triangles, -- LOB containing the triangles
r.num_points, -- # of points in the LOB
r.num_triangles, -- # of triangles in the LOB
2, -- Index dimensionality: dim value in SDO_GTYPE
-- of extent in SDO_TIN_PKG.INIT
3, -- Total dimensionality of the points in the LOB
8307 -- SRID
) FROM qryres r;
