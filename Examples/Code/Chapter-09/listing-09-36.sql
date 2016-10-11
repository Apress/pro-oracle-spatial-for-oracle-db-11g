-- Listing 9-36. Computing the MBR of a Geometry
SELECT SDO_GEOM.SDO_MBR(sr.geom) mbr FROM sales_regions sr
WHERE sr.id=1;
