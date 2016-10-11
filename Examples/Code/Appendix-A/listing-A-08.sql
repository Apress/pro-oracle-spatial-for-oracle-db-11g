-- Listing A-8. Simplifying the Geometry for New Hampshire
SELECT sdo_util.getnumvertices(geom) orig_num_vertices,
sdo_util.getnumvertices(sdo_sam.simplify_geometry(geom, 0.5)) new_num_vertices
FROM states
WHERE state_abrv='NH';
