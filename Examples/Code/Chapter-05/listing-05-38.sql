-- Listing 5-38. Example of Removing Duplicate Vertices in a Geometry
SELECT geom, SDO_UTIL.REMOVE_DUPLICATE_VERTICES(sr.geom,0.5) nodup_geom
FROM sales_regions sr
WHERE id=1000;
